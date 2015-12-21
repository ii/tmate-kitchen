#!/usr/bin/env ruby
require 'json'
require './nodes/_definitions'

class Graph
  def initialize
    @hosts = NodeDefinitions.common[:hosts]
               .to_a
               .uniq { |k,v| v }
               .map { |k,v| k }
               .reject { |h| h == :monitor }
               .reject { |h| h == :master1 }
  end

  def colors
    {
      sg: "#f3ec1a",
      sf: "#0d35ff",
      ny: "#ee0dcc",
      am: "#23e909",
      fk: "#c03300",
      ln: "#00c0c0",
      to: "#ffffff",
    }
  end

  def host_title(host)
    host.to_s.tr('0-9', '').upcase
  end

  def host_color(host)
    colors[host.to_s.tr('0-9', '').to_sym]
  end

  def cpu
    {
      title: "CPU",
      target: %w(steal system user wait nice).zip(%w(white red blue gray green)).map do |what, color|
        "alias(scale(color(derivative(sumSeries(keepLastValue(collectd.*.cpu.*.cpu.#{what}, 10))), '#{color}'), 0.001), '#{what}')"
      end,
      areaMode: "stacked",
      yMin: "0",
      yMax: "2",
    }
  end

  def mem
    {
      title: "Memory",
      target: @hosts.map { |host| "color(alias(collectd.#{host}.memory.memory.used, '#{host_title(host)}'),'#{host_color(host)}')" },
    }
  end

  def net
    {
      title: "Net",
      target: [
        "alias(scaleToSeconds(derivative(sumSeries(keepLastValue(collectd.*.interface.eth0.if_octets.rx, 10))),1),'RX')",
        "alias(scaleToSeconds(derivative(sumSeries(keepLastValue(collectd.*.interface.eth0.if_octets.tx, 10))),1),'TX')"
      ],
      yMin: "0",
    }
  end

  def paired_live
    {
      title: "Live Paired Sessions",
      target: @hosts.map { |host| "legendValue(color(alias(stats.gauges.tmate.#{host}.sessions.paired,'#{host_title(host)}'),'#{host_color(host)}'),'last')" },
      areaMode: "stacked",
      yMin: "0",
      yMax: "30",
    }
  end

  def paired_cumul
    {
      title: "Cumulative Paired Sessions",
      target: @hosts.map { |host| "legendValue(color(alias(integral(stats_counts.tmate.#{host}.sessions.paired.total),'#{host_title(host)}'),'#{host_color(host)}'),'last')" },
      areaMode: "stacked",
      yMin: "0",
    }
  end


  def graph_def
    [cpu, mem, net, paired_live, paired_cumul]
  end
end

puts JSON.pretty_generate(Graph.new.graph_def)
