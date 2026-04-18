{
  replaceDependencies,
  davinci-resolve-studio,
  hexdump,
  ...
}: 
let
  nonFhsOriginalDavici = davinci-resolve-studio.passthru.davinci;
  davinciPatched = nonFhsOriginalDavici.overrideAttrs (
    _final: _prev: {
      # https://stackoverflow.com/a/17168777
      preFixup = ''
        pattern="\x55\x41\x57\x41\x56\x53\x48\x83\xec.\x49\x89\xfe\xc7\x47\x34\xff\xff\xff\xff\x85\xf6\x0f\x84....\x89\xf5\x81\xfe\x13\xfc\xff\xff\x0f\x85"
        offset=23
        file="$out/bin/resolve"
        matches=$(LANG=C grep -obUaP "$pattern" "$file")
        matchcount=$(echo "$matches" | wc -l)
        if [[ -z $matches ]]; then echo "pattern not found";
          elif [[ $matchcount -ne 1 ]]; then echo "pattern returned $matchcount matches instead of 1";
        else
          patternOffset=$(echo $matches | cut -d: -f1)
          instructionOffset=$(($patternOffset + $offset))
          echo "patching byte '0x$(${hexdump}/bin/hexdump -s $instructionOffset -n 1 -e '/1 "%02x"' "$file")' at offset $instructionOffset"
          echo -en "\x85" | dd conv=notrunc of="$file" bs=1 seek=$instructionOffset count=1;
        fi
      '';
    }
  );
in replaceDependencies {
  drv = davinci-resolve-studio;
  replacements = [
    {
      oldDependency = nonFhsOriginalDavici;
      newDependency = davinciPatched;
    }
  ];
}
