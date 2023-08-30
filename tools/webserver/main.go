package main

import (
	"flag"
	"log"
	"net/http"
)

func main() {
	// flags
	var listenAddress, contentDir string
	flag.StringVar(&listenAddress, "listenAddress", ":8080", "webserver bind address")
	flag.StringVar(&contentDir, "contentDir", "releases/web", "/path/to/web/game")

	// server
	fileServer := http.FileServer(http.Dir(contentDir))

	http.Handle("/", addHeaders(fileServer))
	log.Println("Running game server, listening to :8080...")
	err := http.ListenAndServe(listenAddress, nil)
	if err != nil {
		log.Fatal(err)
	}
}

func addHeaders(handler http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Add custom headers
		w.Header().Set("Cross-Origin-Opener-Policy", "same-origin")
		w.Header().Set("Cross-Origin-Embedder-Policy", "require-corp")

		// Call the original handler
		handler.ServeHTTP(w, r)
	})
}
