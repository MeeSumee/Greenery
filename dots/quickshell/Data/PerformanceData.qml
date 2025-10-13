pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

import qs.Data as Dat
import qs.Panels as Pan

Singleton {
  id: root

  property alias cpu: cpuInfo
  property alias mem: memInfo
  property string uptime: "0:00"

  // stolen from what rex stole from friday who stole from pterror
  FileView {
    id: cpuInfo

    property int idle
    property int idleSec
    property int total
    property int totalSec

    path: "/proc/stat"

    onLoaded: {
      const data = cpuInfo.text();
      if (!data) {
        return;
      }
      const cpuText = data.match(/^.+/)[0];
      const [user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = cpuText.match(/\d+/g).map(Number);
      const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice;
      cpuInfo.idleSec = newIdle - cpuInfo.idle;
      cpuInfo.totalSec = newTotal - cpuInfo.total;
      cpuInfo.idle = newIdle;
      cpuInfo.total = newTotal;
    }
  }

  // more stolen content
  FileView {
    id: memInfo

    property int free
    property int total

    path: "/proc/meminfo"

    onLoaded: {
      const text = memInfo.text();
      if (!text) {
        return;
      }

      memInfo.total = Number(text.match(/MemTotal: *(\d+)/)[1] ?? 1);
      memInfo.free = Number(text.match(/MemAvailable: *(\d+)/)[1] ?? 0);
    }
  }

  Timer {
    interval: 1000
    repeat: true
    running: Pan.Bar.barfull.state == "FULLY_EXPANDED" && Pan.Panel.content.swipeIndex == 3

    onTriggered: {
      cpuInfo.reload();
      memInfo.reload();
    }
  }

  Process {
    id: uptime

    command: ["uptime"]

    stdout: StdioCollector {
      onStreamFinished: {
        // my regex skills are segs
        const time = text.match(/((\d+:?)+?(?=,))/)[0];
        const days = text.match(/(\d+) days /) ?? [""];
        root.uptime = days[0] + time;
      }
    }
  }

  Timer {
    interval: 1000 * 60
    repeat: true
    running: Dat.Globals.notchState == "FULLY_EXPANDED" && Dat.Globals.swipeIndex == 0
    triggeredOnStart: true

    onTriggered: {
      uptime.running = true;
    }
  }
}
