{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  python3,
}: let
  # Pinned so the export is reproducible - the upstream Docker recipe just
  # `git clone`s the default branch, which nix can't do reproducibly.
  # To bump: pick a new commit and update both rev and hash together.
  rev = "5b1ea9a8b3f0ffe4fe0e203ec6232d788bb3fcff";

  # Official pretrained YOLOv9-t weights (stable, versioned GitHub release asset)
  weights = fetchurl {
    url = "https://github.com/WongKinYiu/yolov9/releases/download/v0.1/yolov9-t-converted.pt";
    hash = "sha256-YeCA6WTmXjK4hEd8XmNExgfH4CED1kZJ3oEO2uuGmAM=";
  };

  # Everything export.py pulls in transitively through models/yolo.py, models/common.py
  # and the utils/* modules it imports at module load time - traced by hand since
  # upstream's requirements.txt also carries training-only extras (albumentations,
  # pycocotools, tensorboard, seaborn, thop, gitpython, scipy) that aren't actually
  # imported on the `--include onnx` export path (albumentations is a lazy/optional
  # import; the rest simply aren't referenced by this path at all).
  pythonEnv = python3.withPackages (ps:
    with ps; [
      torch
      torchvision
      numpy
      pandas
      requests
      pyyaml
      psutil
      tqdm
      opencv4
      pillow
      ipython
      matplotlib
      seaborn
      onnx
      onnxruntime
      onnxscript
      setuptools
    ]);
in
  stdenv.mkDerivation {
    pname = "frigate-yolov9-onnx-model";
    version = rev;

    src = fetchFromGitHub {
      owner = "WongKinYiu";
      repo = "yolov9";
      inherit rev;
      hash = "sha256-DJ2iM+xb00NKaomUcoe7BI/O7mHNu5ARmy/SJYsCEEg=";
    };

    nativeBuildInputs = [pythonEnv];

    dontConfigure = true;

    patchPhase = ''
      runHook prePatch
      # Trailing ')' closes the torch.load(...) call itself, not a stray bracket -
      # it anchors the match to that one call so we don't touch unrelated map_location='cpu' uses.
      substituteInPlace models/experimental.py \
        --replace-fail "map_location='cpu')" "map_location='cpu', weights_only=False)"
      runHook postPatch
    '';

    buildPhase = ''
      runHook preBuild
      export HOME="$TMPDIR"
      cp ${weights} ./yolov9-t.pt
      python3 export.py --weights ./yolov9-t.pt --imgsz 320 --include onnx
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm444 yolov9-t.onnx "$out/yolov9-t-320.onnx"
      runHook postInstall
    '';

    meta = {
      description = "YOLOv9-t ONNX model exported for Frigate's OpenVINO detector";
      homepage = "https://github.com/WongKinYiu/yolov9";
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.linux;
    };
  }
