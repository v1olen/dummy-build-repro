# 406 Dummy Build Repro

This minimal reproduction demonstrates a bug that occurs when you try to use a release bundle built on docker (or maybe just Linux).

The repo itself is just a "Jumpstart" template from Dioxus, with the router and fullstack features enabled. The only changes are Dockerfile, this README and `.dockerignore` file.

Steps to reproduce:

1. Build the docker image:
    ```bash
    docker buildx build \
        --file Dockerfile \
        --platform linux/amd64 \
        -t dummy-build-repro \
        .
    ```

1. Run it with:
    ```bash
    docker run -it --name dummy-build-repro dummy-build-repro
    ```

1. In another terminal, try to run curl to the homepage (from inside the container to exclude network issues):
    ```bash
    docker exec -it dummy-build-repro curl 127.0.0.1:8080 -v
    ```

1. You should see the 406:
    ```
    ➜  dummy-build-repro docker exec -it dummy-build-repro curl 127.0.0.1:8080 -v
    *   Trying 127.0.0.1:8080...
    * Connected to 127.0.0.1 (127.0.0.1) port 8080 (#0)
    > GET / HTTP/1.1
    > Host: 127.0.0.1:8080
    > User-Agent: curl/7.88.1
    > Accept: */*
    > 
    < HTTP/1.1 406 Not Acceptable
    < content-length: 0
    < date: Sun, 13 Apr 2025 13:34:00 GMT
    < 
    * Connection #0 to host 127.0.0.1 left intact
    ```

What's interesting is that if you set up asset_dir in the Dioxus.toml the static files are served correctly, but the homepage still returns 406.

Simultaneously, building the same repository natively on my aarch64 Mac works fine. I don't currently have access to any x86_64 machine with Linux to test it to differentiate if it's docker or Linux being the factor.
