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

type ShortenURLResponse struct {
	Short_URL string `json:"short_url"`
}

func ShortenURLHandler(w http.ResponseWriter, r *http.Request) {
	body, _ := io.ReadAll(r.Body)
	var request ShortenURLRequest
	json.Unmarshal(body, &request)

	longUrl := request.Long_URL

	shortURL := shortening.ShortenURL(longUrl)
	shortUrlResponse := ShortenURLResponse{Short_URL: shortURL}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(shortUrlResponse)
}
