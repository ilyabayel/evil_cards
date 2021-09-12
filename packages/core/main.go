package main

import (
	"bufio"
	"fmt"
	"os"
	"sync"
)

func main() {
	fmt.Println("hello")
	var wg sync.WaitGroup

	c := make(chan string)

	go roomHandler(c, &wg)
	go roomHandler(c, &wg)

	reader := bufio.NewReader(os.Stdin)
	fmt.Print("Enter text: ")

	for {
		text, _ := reader.ReadString('\n')
		c <- text

		if text == "end" {
			break
		}
	}
}

func roomHandler(c chan string, wg *sync.WaitGroup) {
	for {
		line := <-c
		fmt.Println(line)

		if line == "end" {
			break
		}
	}
}
