package main

import (
	"flag"

	"log"

	iclient "github.com/RedHatInsights/insights-goapi/client"
	"github.com/RedHatInsights/insights-goapi/container"
)

func main() {
	scanOptions := container.NewDefaultImageMounterOptions()
	flag.StringVar(&scanOptions.DstPath, "mount_path", scanOptions.DstPath, "Image to scan")
	flag.StringVar(&scanOptions.Image, "image", scanOptions.Image, "Docker image to scan")
	flag.Parse()
	mounter := container.NewDefaultImageMounter(*scanOptions)
	_, image, _ := mounter.Mount()

	scanner := iclient.NewDefaultScanner()

	_, out, err := scanner.ScanImage(scanOptions.DstPath, image.ID)
	if err != nil {
		log.Fatalf("Scan failed %s", err)
	}
	log.Printf(string(*out))
}
