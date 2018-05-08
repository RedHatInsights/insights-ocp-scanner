package main

import (
	"os"
	"flag"
	"path"
	"io/ioutil"
	"log"
	"fmt"

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

	log.Printf(scanOptions.DstPath)

    rhaiDir := path.Join(scanOptions.DstPath, "etc", "redhat-access-insights")
    machineidPath := path.Join(rhaiDir, "machine-id")
    os.MkdirAll(rhaiDir, os.ModePerm)
    err := ioutil.WriteFile(machineidPath, []byte("deeznuts"), 0644)
    if err != nil {
        panic(err)
    }

	scanner := iclient.NewDefaultScanner()

	_, out, err := scanner.ScanImage(scanOptions.DstPath, image.ID)

	if err != nil {
		fmt.Printf("ERROR: Scan failed %s", err)
		return
	}
	fmt.Print(string(*out))
}
