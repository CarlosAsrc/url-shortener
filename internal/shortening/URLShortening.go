package shortening

import (
	"fmt"
	"hash/crc32"
)

func ShortenURL(longUrl string) string {
	hasher := crc32.NewIEEE()
	hasher.Write([]byte(longUrl))
	return fmt.Sprintf("%x", hasher.Sum32())
}
