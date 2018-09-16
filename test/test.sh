#!/usr/bin/env bash
set -e

main() {
    dir="$( cd "$(dirname "$0")" && pwd )"

    gnuver=$(sed --version 2>/dev/null | grep GNU | grep -E -o '[0-9]+\.[0-9]+' || true)
    if [ -n "$gnuver" ] && less_than_4_2 $gnuver; then
        args="-r"
    else
        args="-E"
    fi

    diff "$dir/expected.txt" <(sed $args -f "$dir/../junit4-to-5.sed" "$dir/test.txt")

    tests4=$(mvn_test "$dir/junit4.pom.xml")
    find "$dir/src" -name \*.java -exec sed $args -i.bak -f "$dir/../junit4-to-5.sed" {} \;
    find "$dir/src" -name \*.java.bak -delete
    tests5=$(mvn_test "$dir/junit5.pom.xml")
    diff <(echo "$tests4") <(echo "$tests5")
}

mvn_test() {
    local file="$1"
    mvn -B -f "$file" clean test \
        | sed -n '/Results:/,/Tests run:/p'
}

less_than_4_2() {
    local ver="$1"
    if [ -n "$ver" ] && [ ${ver%.*} -lt 4 -o ${ver%.*} -eq 4 -a ${ver#*.} -lt 2 ]; then
        true
    else
        false
    fi
}

less_than_4_2 "1.17"
less_than_4_2 "3.02"
less_than_4_2 "4.1"
! less_than_4_2 "4.2"
! less_than_4_2 "4.4"
! less_than_4_2 "30.0"

main "$@"

