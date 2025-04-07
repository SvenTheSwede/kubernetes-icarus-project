package main

import (
    "fmt"
    "log"
    "net/http"
)

func main() {
    http.HandleFunc("/", HomePage)
    log.Fatal(http.ListenAndServe(":8080", nil))
}

func HomePage(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, the site is running :)")
}

