#!/bin/bash



install_server () {
  wget -O - https://raw.githubusercontent.com/KMU-Incident-Response/KMU-Basis-Logging/main/wazuh_server/installer.sh | bash
}
install_rules () {
  wget -O - https://raw.githubusercontent.com/KMU-Incident-Response/ossec-sysmon/master/installer.sh | bash
}

while getopts "anho" opt; do
  case $opt in
    n)
      install_server
      exit 0
      ;;
    o)
      install_rules
      exit 0
      ;;
    a)
      install_server
      install_rules
      exit 0
      ;;
    \?)
      printf "script usage:\n -n\t no rules (Install server without rules)\n -o\t only rules (Install only custom rules, no server)\n -h\t print usage\n" >&2
      exit 1
      ;;
    h)
      printf "script usage:\n -a\t Install Wazuh server and rules\n -n\t no rules (Install server without rules)\n -o\t only rules (Install only custom rules, no server)\n -h\t print usage\n" >&2
      exit 1
      ;;
  esac
done



printf "To display usage use -h\n\nNo argument provided, exiting... \n"