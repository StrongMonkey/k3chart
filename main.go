package main

import (
	"fmt"
	"gopkg.in/yaml.v3"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
)

type Question struct {
	Key         string
	Value       string
	Description string
}

func main() {
	if err := filepath.Walk("./packages", func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			return nil
		}
		if info.Name() == "values.yaml" {
            data, err := ioutil.ReadFile(path)
            if err != nil {
            	return err
			}
			n := &yaml.Node{}
			if err := yaml.Unmarshal(data, n); err != nil {
				return err
			}
			qss := traverse(n, "")
			output, err := yaml.Marshal(qss)
			if err != nil {
				return err
			}
			fmt.Println(string(output))
		}
		return nil
	}); err != nil {
		panic(err)
	}
}

func traverse(node *yaml.Node, prefix string) []Question {
	var result []Question
	if node == nil {
		return []Question{}
	}

	if node.Kind == yaml.ScalarNode {
		result = append(result, Question{
			Key: strings.Trim(prefix, "."),
			Value: node.Value,
			Description: node.HeadComment + node.FootComment + node.LineComment,
		})
	} else {
		for _, child := range node.Content {
			qs := traverse(child, prefix+node.Value+".")
			result = append(result, qs...)
		}
	}
	return result
}
