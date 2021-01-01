#! /system/bin/sh
config="$1"
PERFETTO_ACTIVATE_TRIGGER='activate_triggers: "default_trigger_config"'
PERFETTO_CONFIG='
trigger_config {
  trigger_mode: START_TRACING
  triggers {
    name: "default_trigger_config"
    stop_delay_ms: 5000
  }
  trigger_timeout_ms: 120000
}
write_into_file: true
flush_period_ms: 30000
max_file_size_bytes: 209715200
buffers {
  size_kb: 131072
  fill_policy: RING_BUFFER
}
buffers {
  size_kb: 2048
  fill_policy: RING_BUFFER
}
data_sources {
    config {
        name: "linux.ftrace"
        target_buffer: 0
        ftrace_config {
            ftrace_events: "sched/sched_switch"
            ftrace_events: "power/suspend_resume"
            ftrace_events: "sched/sched_wakeup"
            ftrace_events: "sched/sched_wakeup_new"
            ftrace_events: "sched/sched_waking"
            ftrace_events: "sched/sched_process_exit"
            ftrace_events: "sched/sched_process_free"
            ftrace_events: "task/task_newtask"
            ftrace_events: "task/task_rename"
            ftrace_events: "power/cpu_frequency"
            ftrace_events: "power/cpu_idle"
            ftrace_events: "lowmemorykiller/lowmemory_kill"
            ftrace_events: "oom/oom_score_adj_update"
            ftrace_events: "ftrace/print"
            atrace_categories: "gfx"
            atrace_categories: "input"
            atrace_categories: "view"
            atrace_categories: "webview"
            atrace_categories: "wm"
            atrace_categories: "am"
            atrace_categories: "sm"
            atrace_categories: "hal"
            atrace_categories: "res"
            atrace_categories: "dalvik"
            atrace_categories: "rs"
            atrace_categories: "bionic"
            atrace_categories: "power"
            atrace_categories: "pm"
            atrace_categories: "ss"
            atrace_categories: "network"
            atrace_categories: "adb"
            atrace_categories: "vibrator"
            atrace_categories: "aidl"
            atrace_categories: "nnapi"
            atrace_categories: "rro"
            atrace_apps: "lmkd"
        }
    }
}
data_sources: {
    config {
        name: "linux.process_stats"
        target_buffer: 1
        process_stats_config {
            scan_all_processes_on_start: true
        }
    }
}
data_sources: {
    config {
        name: "linux.sys_stats"
        target_buffer: 1
        sys_stats_config {
            stat_period_ms: 1000
            stat_counters: STAT_CPU_TIMES
            stat_counters: STAT_FORK_COUNT
        }
    }
}
'

function startPerfetto(){
    TRIGGER_MODE='STOP_TRACING'
    STOP_DELAY='1000'
    CURTIME=`date +%F-%H-%M-%S`
    echo "
trigger_config {
  trigger_mode: $TRIGGER_MODE
  triggers {
    name: \"default_trigger_config\"
    stop_delay_ms: $STOP_DELAY
  }
  trigger_timeout_ms: 60000
}
write_into_file: true
flush_period_ms: 30000
max_file_size_bytes: 209715200
buffers {
  size_kb: 131072
  fill_policy: RING_BUFFER
}
buffers {
  size_kb: 2048
  fill_policy: RING_BUFFER
}
data_sources {
    config {
        name: \"linux.ftrace\"
        target_buffer: 0
        ftrace_config {
            ftrace_events: \"sched/sched_switch\"
            ftrace_events: \"power/suspend_resume\"
            ftrace_events: \"sched/sched_wakeup\"
            ftrace_events: \"sched/sched_wakeup_new\"
            ftrace_events: \"sched/sched_waking\"
            ftrace_events: \"sched/sched_process_exit\"
            ftrace_events: \"sched/sched_process_free\"
            ftrace_events: \"task/task_newtask\"
            ftrace_events: \"task/task_rename\"
            ftrace_events: \"power/cpu_frequency\"
            ftrace_events: \"power/cpu_idle\"
            ftrace_events: \"lowmemorykiller/lowmemory_kill\"
            ftrace_events: \"oom/oom_score_adj_update\"
            ftrace_events: \"ftrace/print\"
            atrace_categories: \"gfx\"
            atrace_categories: \"input\"
            atrace_categories: \"view\"
            atrace_categories: \"webview\"
            atrace_categories: \"wm\"
            atrace_categories: \"am\"
            atrace_categories: \"sm\"
            atrace_categories: \"hal\"
            atrace_categories: \"res\"
            atrace_categories: \"dalvik\"
            atrace_categories: \"rs\"
            atrace_categories: \"bionic\"
            atrace_categories: \"power\"
            atrace_categories: \"pm\"
            atrace_categories: \"ss\"
            atrace_categories: \"network\"
            atrace_categories: \"adb\"
            atrace_categories: \"vibrator\"
            atrace_categories: \"aidl\"
            atrace_categories: \"nnapi\"
            atrace_categories: \"rro\"
            atrace_apps: \"lmkd\"
        }
    }
}
data_sources: {
    config {
        name: \"linux.process_stats\"
        target_buffer: 1
        process_stats_config {
            scan_all_processes_on_start: true
        }
    }
}
data_sources: {
    config {
        name: \"linux.sys_stats\"
        target_buffer: 1
        sys_stats_config {
            stat_period_ms: 1000
            stat_counters: STAT_CPU_TIMES
            stat_counters: STAT_FORK_COUNT
        }
    }
}" | perfetto -c - --txt -o /data/misc/perfetto-traces/trace_${CURTIME}
    #echo $PERFETTO_CONFIG | perfetto -c - --txt -o /data/misc/perfetto-traces/trace_${CURTIME}
}

function stopPerfetto(){
    echo $PERFETTO_ACTIVATE_TRIGGER | perfetto -c - --txt
}

case "$config" in
    "perfettostart")
        startPerfetto
        ;;
    "perfettostop")
        stopPerfetto
        ;;
    *)
        ;;
esac