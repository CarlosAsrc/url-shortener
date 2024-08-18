package config

import (
	"log"
	"os"

	"github.com/spf13/viper"
)

type Config struct {
	Region    string
	TableName string
}

func GetConfig() Config {

	env := os.Getenv("GO_ENV")
	if env == "" {
		env = "development"
	}

	viper.SetConfigName(env)
	viper.SetConfigType("yml")
	viper.AddConfigPath("./config")
	viper.AddConfigPath("/app/config")

	err := viper.ReadInConfig()
	if err != nil {
		log.Fatalf("Error reading config file, %s", err)
	}

	return Config{
		Region:    viper.GetString("dynamodb.region"),
		TableName: viper.GetString("dynamodb.table_name"),
	}
}
