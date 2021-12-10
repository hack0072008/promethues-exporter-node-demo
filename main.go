package main

import (
	"fmt"
	"github.com/hack0072008/promethues-exporter-node-demo/pkg/collector"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"net/http"
)

func init() {
	// path := flag.String()
	// port := flag.IntVar()

	//注册自身采集器
	prometheus.MustRegister(collector.NewNodeCollector())
}

func main() {
	http.Handle("/metrics", promhttp.Handler())

	fmt.Println("Server will start at :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Printf("Error occur when start server %v", err)
	}
	fmt.Println("Server stop!")
}
