package routes

import (
	"github.com/CarlosAsrc/url-shortener/api/handlers"
	"github.com/gorilla/mux"
)

func SetupRoutes() *mux.Router {
	router := mux.NewRouter()
	router.HandleFunc("/shorten", handlers.ShortenURLHandler).Methods("POST")
	return router
}
