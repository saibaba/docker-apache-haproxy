package main

import "os/exec"

func main() {
    app := "docker"
    arg0 := "ps"

    cmd := exec.Command(app, arg0)
    out, err := cmd.Output()
    if err != nil {
        println(err.Error())
    } else {
        print(string(out))
    }
}
