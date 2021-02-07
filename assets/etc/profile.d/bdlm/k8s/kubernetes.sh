#!/bin/bash

# kx() - Authenticate into a kubernetes cluster and set the appropriate context.
# If no arguments are passed, print the current context.
#
#    kx [profile] [env] [workload]
#        profile
#            One of "eo" or "vfe". The special value "-" will switch back to the
#            most recently used context.
#        env
#            One of "test" or "prod".
#        workload
#            The workload number to work with (1, 2, 3, etc.).
#   eg.
#       `kx vfe test 1`
#           Set the kubectl context to the vfe-test workload1 cluster.
#       `kx eo prod 4`
#           Set the kubectl context to the eo-prod workload4 cluster.
#       `kx -`
#           Set the kubectl context back to the vfe-test workload1 cluster.
#
#
# kn() - Get/set the namespace for the current k8s context. If no argument is
# passed, print the current namespace.
#
#   kn -
#       Switch to the most recently used namespace in the current context.
#   kn <namespace>
#       Set the current namespace to <namespace>.
#
#
# __k8s_ps1() - Kubernetes status line for shell prompts. Displays an icon and
# the current kubectl context and namespace:
#
#   '⎈ {context}::{namespace}'

alias k="kubectl"

# ⎈ UTF-8 kubernetes icon.
if [ "" = "$__K8S_PS1_SYMBOL" ]; then
    export __K8S_PS1_SYMBOL=$'\xE2\x8E\x88'
fi

# init k8s context management variables
if [ -d "$HOME/.kube" ]; then
    export __K8S_LAST_CONTEXT=
    export __KUBECONFIG_DEFAULT=$HOME/.kube/config
    export KUBECONFIG=$__KUBECONFIG_DEFAULT
    export -A __K8S_LAST_NAMESPACE
    export -A __K8S_CURR_NAMESPACE

    current_context=$(kubectl config view -o=jsonpath='{.current-context}' 2> /dev/null)
    current_ns=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${currrent_context}\")].context.namespace}" 2> /dev/null)
    if [ "" != "$current_ns" ]; then
        current_ns="default"
    fi

    if [ "" != "$current_context" ]; then
        export -A __K8S_LAST_NAMESPACE=([$current_context]=default)
        export -A __K8S_CURR_NAMESPACE=([$current_context]=$current_ns)
    fi
fi

# kn() - Get/set the namespace for the current k8s context. If no argument is
# passed, print the current namespace.
#
# i.e. `kn infrastructure`
# i.e. `kn -` // switches back
kn() {
    currrent_context="$(kx)"
    if [ "" == "$currrent_context" ]; then
        >&2 echo "kubernetes context is not set"
        $(exit 1)
        return
    fi

    current_ns=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${currrent_context}\")].context.namespace}" 2> /dev/null)
    if [ "" = "$current_ns" ]; then
        current_ns="default"
    fi

    if [ "" == "${__K8S_LAST_NAMESPACE[$currrent_context]}" ]; then
        __K8S_LAST_NAMESPACE[$currrent_context]=$current_ns
    fi
    if [ "" == "${__K8S_CURR_NAMESPACE[$currrent_context]}" ]; then
        __K8S_CURR_NAMESPACE[$currrent_context]=$current_ns
    fi

    if [ "" == "$1" ]; then
        echo $current_ns
    elif [ "-" == "$1" ]; then
        kubectl config set-context "${currrent_context}" --namespace="${__K8S_LAST_NAMESPACE[$currrent_context]}" > /dev/null
        __K8S_LAST_NAMESPACE[$currrent_context]=$current_ns
        __K8S_CURR_NAMESPACE[$currrent_context]=${__K8S_LAST_NAMESPACE[$currrent_context]}
        __k8s_ps1
    else
        kubectl config set-context "${currrent_context}" --namespace="$1" > /dev/null
        __K8S_LAST_NAMESPACE[$currrent_context]=$current_ns
        __K8S_CURR_NAMESPACE[$currrent_context]=$1
        __k8s_ps1
    fi

    eval "export -A __K8S_LAST_NAMESPACE"
    eval "export -A __K8S_CURR_NAMESPACE"
}
export -f kn

# kx() - Authenticate into a kubernetes cluster and set the appropriate context.
# If no arguments are passed, print the current context.
#
# i.e. `kx eo test 1`
kx() {
    cluster=
    env=
    default_namespace=
    profile=
    workload="workload${3}"

    if [ "" == "$__K8S_LAST_CONTEXT" ]; then
        eval "export __K8S_LAST_CONTEXT=$(kubectl config view -o=jsonpath='{.current-context}' 2> /dev/null)"
    fi

    case "$1" in
        "eo")
            profile=$1
            if [ "test" == "$2" ]; then
                env="tst."
            fi
            cluster="${workload}.k8s.${env}returnpath.net"
            default_namespace="eo"

            eval "export __K8S_LAST_CONTEXT=$(kubectl config view -o=jsonpath='{.current-context}' 2> /dev/null)"

            # TODO
            #$(aquaduck auth kube $cluster --k8s-auth-type=kops -p $profile)
        ;;
        "vfe")
            profile="${1}-${2}"
            cluster="${workload}.k8s.us-east-1.${profile}.validityhq.net"
            default_namespace="vfe"

            eval "export __K8S_LAST_CONTEXT=$(kubectl config view -o=jsonpath='{.current-context}' 2> /dev/null)"
            # TODO
            #$(aquaduck auth kube $cluster --k8s-auth-type=kops -p $profile)
        ;;
        "-")
            cluster=$__K8S_LAST_CONTEXT
            eval "export __K8S_LAST_CONTEXT=$(kubectl config view -o=jsonpath='{.current-context}' 2> /dev/null)"
        ;;
        "")
            echo $(kubectl config view -o=jsonpath='{.current-context}')
            return
        ;;
        *)
            echo "Unknown profile '$1'"
            $(exit 2)
            return
        ;;
    esac

    # Switch to the specified context
    kubectl config use-context $cluster > /dev/null
    current_context=$(kubectl config view -o=jsonpath='{.current-context}' 2> /dev/null)
    if [ "" != "$default_namespace" ]; then
        if [ "" == "${__K8S_CURR_NAMESPACE[$current_context]}" ]; then
            __K8S_CURR_NAMESPACE[$current_context]=$default_namespace
            eval "export -A __K8S_CURR_NAMESPACE"
        fi
    fi

    # Make sure it lands in the expected namespace
    kn ${__K8S_CURR_NAMESPACE[$current_context]}
}
export -f kx

# __k8s_ps1() - Kubernetes status line for shell prompts. Displays an icon and
# the current kubectl context and namespace.
#
# '⎈ {context}::{namespace}'
__k8s_ps1() {
    echo "$__K8S_PS1_SYMBOL$(kx)::$(kn)"
}
export -f __k8s_ps1
