{
  lib,
  config,
  pkgs,
  ...
}: let
  # 80-class COCO labelmap expected by Frigate's yolo-generic model type -
  # not the 91-class OpenVINO labelmap Frigate bundles for its own SSD model.
  coco80Labelmap = pkgs.writeText "coco-80.txt" (lib.concatStringsSep "\n" [
    "person" "bicycle" "car" "motorcycle" "airplane" "bus" "train" "truck" "boat"
    "traffic light" "fire hydrant" "stop sign" "parking meter" "bench" "bird" "cat"
    "dog" "horse" "sheep" "cow" "elephant" "bear" "zebra" "giraffe" "backpack"
    "umbrella" "handbag" "tie" "suitcase" "frisbee" "skis" "snowboard" "sports ball"
    "kite" "baseball bat" "baseball glove" "skateboard" "surfboard" "tennis racket"
    "bottle" "wine glass" "cup" "fork" "knife" "spoon" "bowl" "banana" "apple"
    "sandwich" "orange" "broccoli" "carrot" "hot dog" "pizza" "donut" "cake" "chair"
    "couch" "potted plant" "bed" "dining table" "toilet" "tv" "laptop" "mouse"
    "remote" "keyboard" "cell phone" "microwave" "oven" "toaster" "sink"
    "refrigerator" "book" "clock" "vase" "scissors" "teddy bear" "hair drier"
    "toothbrush"
  ]);
in {
  options.greenery.server.frigate.enable = lib.mkEnableOption "Frigate NVR service";

  config = lib.mkIf (config.greenery.server.frigate.enable && config.greenery.server.enable) {
    # Frigate NVR Server
    services = {
      frigate = {
        enable = true;
        # SupplementaryGroups already includes "render", so no extra group needed for iGPU access
        vaapiDriver = "iHD";
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

          cameras.usb_camera = {
            ffmpeg.inputs = [
              {
                path = "/dev/video0";
                # Tune resolution/format/framerate to match `v4l2-ctl --list-formats-ext -d /dev/video0`
                input_args = ["-f" "v4l2" "-input_format" "mjpeg" "-video_size" "1280x720" "-framerate" "15"];
                roles = ["detect" "record"];
              }
            ];
            detect = {
              width = 1280;
              height = 720;
              fps = 5;
            };
          };
        };
      };
      caddy = {
        enable = true;
        virtualHosts."https://frigate.onca-ph.ts.net" = {
          extraConfig = ''
            bind tailscale/frigate
            reverse_proxy localhost:5000
          '';
        };
      };
    };

    # Frigate hardcodes its storage (db/clips/recordings) under /var/lib/frigate,
    # so relocate it onto external storage via a bind mount rather than a service option.
    fileSystems."/var/lib/frigate" = {
      device = "/run/media/sumee/emerald/services/frigate";
      options = ["bind" "nofail"];
    };

    systemd.services.frigate = {
      wants = ["var-lib-frigate.mount"];
      after = ["var-lib-frigate.mount"];
    };

    # Best-effort: only succeeds once the emerald drive is mounted
    systemd.tmpfiles.rules = [
      "d /run/media/sumee/emerald/services/frigate 0750 frigate frigate -"
    ];

    # For /dev/video0 access
    users.users.frigate.extraGroups = ["video"];
  };
}
