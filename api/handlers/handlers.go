package handlers

import (
	"encoding/json"
	"io"
	"net/http"

	"github.com/CarlosAsrc/url-shortener/internal/shortening"
)

type ShortenURLRequest struct {
	Long_URL string `json:"long_url"`
}

func ShortenURLHandler(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)
	var request ShortenURLRequest
	json.Unmarshal(body, &request)

	longUrl := request.Long_URL

	shortURL := shortening.ShortenURL(longUrl)
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte(shortURL))
}
