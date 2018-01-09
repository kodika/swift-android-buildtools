#!/bin/bash
: "${SWIFT_ANDROID_HOME:?$SWIFT_ANDROID_HOME should be set}"
: "${ANDROID_NDK_HOME:?$ANDROID_NDK_HOME should be set}"

if [[ "$*" =~ " -fileno " ]]; then
    # remove trailing slashes
    SWIFT_ANDROID_HOME=$(echo $SWIFT_ANDROID_HOME | sed -e 's%/*$%%')

    xcode_toolchain=$(dirname $(dirname $(dirname $(xcrun --find swiftc))))
    swift_pm_runtime=$xcode_toolchain/usr/lib/swift/pm

    # fix paths to Swift PM runtime keeping args
    args=( "$@" )
    for (( i=0; i< ${#args[*]}; i++ ))
    do
        args[$i]=$(echo "${args[$i]}" | sed -E "s%$SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/pm%$swift_pm_runtime%g")
    done

    swift "${args[@]}" || { 
        return_code=$? 
        echo "*** Error executing: $0 $@"
        exit $return_code
    }
    exit 0
fi

# compile using toolchain's swiftc with Android target
swiftc "$@"
exit $?
