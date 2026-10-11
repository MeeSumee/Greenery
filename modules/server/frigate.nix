{
  lib,
  config,
  pkgs,
  ...
}: let
  # 80-class COCO labelmap expected by Frigate's yolo-generic model type -
  # not the 91-class OpenVINO labelmap Frigate bundles for its own SSD model.
  coco80Labelmap = pkgs.writeText "coco-80.txt" (lib.concatStringsSep "\n" [
    "person"
    "bicycle"
    "car"
    # "motorcycle"
    # "airplane"
    # "bus"
    # "train"
    # "truck"
    # "boat"
    # "traffic light"
    # "fire hydrant"
    # "stop sign"
    # "parking meter"
    # "bench"
    "bird"
    "cat"
    "dog"
    # "horse"
    # "sheep"
    # "cow"
    # "elephant"
    # "bear"
    # "zebra"
    # "giraffe"
    "backpack"
    "umbrella"
    "handbag"
    "tie"
    "suitcase"
    # "frisbee"
    # "skis"
    # "snowboard"
    # "sports ball"
    # "kite"
    # "baseball bat"
    # "baseball glove"
    # "skateboard"
    # "surfboard"
    # "tennis racket"
    "bottle"
    "wine glass"
    "cup"
    "fork"
    "knife"
    "spoon"
    "bowl"
    "banana"
    "apple"
    "sandwich"
    "orange"
    "broccoli"
    "carrot"
    "hot dog"
    "pizza"
    "donut"
    "cake"
    # "chair"
    # "couch"
    # "potted plant"
    # "bed"
    # "dining table"
    # "toilet"
    # "tv"
    "laptop"
    "mouse"
    "remote"
    "keyboard"
    "cell phone"
    "microwave"
    "oven"
    "toaster"
    "sink"
    "refrigerator"
    # "book"
    # "clock"
    # "vase"
    "scissors"
    # "teddy bear"
    "hair drier"
    "toothbrush"
  ]);
in {
  options.greenery.server.frigate.enable = lib.mkEnableOption "Frigate NVR service";

  config = lib.mkIf (config.greenery.server.frigate.enable && config.greenery.server.enable) {
    # Frigate NVR Server
    services = {
      # NixOS packages go2rtc as its own systemd unit (unlike the Docker image, where
      # it runs as a sibling process Frigate launches itself) - services.frigate only
      # declares After=go2rtc.service, it never enables or configures it, so this has
      # to be turned on and given the stream config explicitly or nothing listens on 8554.
      go2rtc = {
        enable = true;
        settings.streams.usb_camera = ["ffmpeg:device?video=0&video_size=1280x720#video=h264"];
      };

      frigate = {
        enable = true;
        checkConfig = true;
        hostname = "localhost";
        settings = {
          mqtt.enabled = false;

          # Uses the 11th gen Intel UHD iGPU for detection instead of the CPU.
          detectors.ov = {
            type = "openvino";
            device = "GPU";
          };

          model = {
            model_type = "yolo-generic";
            width = 320;
            height = 320;
            input_tensor = "nchw";
            input_dtype = "float";
            input_pixel_format = "rgb";
            path = "${pkgs.wo.frigate-yolo-model}/yolov9-t-320.onnx";
            labelmap_path = "${coco80Labelmap}";
          };

          # Hardware-accelerated decode via the same iGPU
          ffmpeg.hwaccel_args = "preset-vaapi";

          # Mirrors services.go2rtc.settings.streams above - frigate.yml needs this too so
          # Frigate's own API/live-view knows the stream exists, but it does NOT start go2rtc.
          go2rtc.streams.usb_camera = ["ffmpeg:device?video=0&video_size=1280x720#video=h264"];

          cameras.usb_camera = {
            enabled = true;
            ffmpeg.inputs = [
              {
                path = "rtsp://127.0.0.1:8554/usb_camera";
                input_args = "preset-rtsp-restream";
                roles = ["detect" "record"];
              }
            ];
            record = {
              enabled = true;
              continuous.days = 0;
              motion.days = 3;
              alerts = {
                retain = {
                  days = 14;
                  mode = "motion";
                };
              };
            };
            detect = {
              enabled = true;
              width = 1280;
              height = 720;
            };
          };
        };
      };

      # Override listen
      nginx.virtualHosts."localhost".listen = [
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];
      # Proxy again
      caddy = {
        enable = true;
        virtualHosts."https://frigate.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/frigate
            reverse_proxy localhost:8080
          '';
        };
      };
    };

    # For /dev/video0 access
    users.users.frigate.extraGroups = ["video"];
  };
}
