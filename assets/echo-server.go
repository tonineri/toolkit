package main

import (
	"encoding/json"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	headers := make(map[string]string)
	for k, v := range r.Header {
		headers[k] = v[0]
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]any{
		"method":  r.Method,
		"path":    r.URL.Path,
		"headers": headers,
	})
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}