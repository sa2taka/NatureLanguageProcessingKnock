package main

import (
	"bufio"
	"fmt"
	"log"
	"math/rand"
	"os"
	"strings"
)

func main() {
	negative_filename := `./rt-polarity.neg`
	positive_filename := `./rt-polarity.pos`

	negative_lines := AddTextToFile(negative_filename, "-1")
	positive_lines := AddTextToFile(positive_filename, "+1")

	sentiment := append(negative_lines, positive_lines...)
	Shuffle(sentiment)

	write_file := NewFile(`./sentiment.txt`)
	defer write_file.Close()
	writer := bufio.NewWriter(write_file)

	sentiment_txt := strings.Join(sentiment, "\n")

	_, write_err := writer.WriteString(sentiment_txt)
	if write_err != nil {
		log.Fatal(write_err)
	}
	writer.Flush()
}

func AddTextToFile(filename, add_text string) []string {
	file, err := os.Open(filename)

	if err != nil {
		fmt.Fprintf(os.Stderr, "File %s could not read: %v\n", filename, err)
		os.Exit(1)
	}

	defer file.Close()

	lines := []string{}
	scanner := bufio.NewScanner(file)

	for scanner.Scan() {
		lines = append(lines, add_text+scanner.Text())
	}

	if serr := scanner.Err(); serr != nil {
		fmt.Fprintf(os.Stderr, "File %s could not scan: %v\n", filename, serr)
	}

	return lines
}

func Shuffle(data []string) {
	n := len(data)
	for i := n - 1; i >= 0; i-- {
		j := rand.Intn(i + 1)
		data[i], data[j] = data[j], data[i]
	}
}

func NewFile(filename string) *os.File {
	file, err := os.OpenFile(filename, os.O_WRONLY|os.O_CREATE, 0755)
	if err != nil {
		log.Fatal(err)
	}

	return file
}
