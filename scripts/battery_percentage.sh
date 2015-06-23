#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

print_battery_percentage() {
   if is_cygwin; then
      WMIC PATH Win32_Battery Get EstimatedChargeRemaining | sed -e '2!d' -e 's/[ \r\n\t]*//g' | awk '{print $1"%";}'
   else
      # percentage displayed in the 2nd field of the 2nd row
      if command_exists "pmset"; then
         pmset -g batt | awk 'NR==2 { gsub(/;/,""); print $2 }'
      elif command_exists "upower"; then
         for battery in $(upower -e | grep battery); do
            upower -i $battery | grep percentage | awk '{print $2}'
         done | xargs echo
      elif command_exists "acpi"; then
         acpi -b | grep -Eo "[0-9]+%"
      fi
   fi
}

main() {
	print_battery_percentage
}
main
