# Notes

The base image used for the "git-cli" task in the Tekton pipeline can be found here.

First and foremost the "alpine:git" image is used by default as found [here](https://github.com/tektoncd/catalog/blob/main/task/git-cli/0.4/git-cli.yaml#L57). As such, the initial layers of the dockerfile (in addition to the VOLUME and WORKDIR directives) were used. The respective dockerfile can be found [here](https://github.com/alpine-docker/git/blob/master/Dockerfile).

Since this image is to also perform oc commands, the latest binary (at the time of writing) was downloaded and installed into the local file system. In addition, the following binaries were also installed (in addition the binaries already present in the parent Dockerfile) using alpine's package manager:

1) Bash: Alpine does not contain bash by default. Although not required it greatly simplified the scripting component of it. The script executed has bash in the shebang line now (was sh by default)
2) Yq: Although not critical, extracting information from YAML files is greatly simplified using this utility. And I anticipate this will be used in more instances moving forward.
3) Finally, libc-compat was used. Long story short alpine images, unlike most linux disributions, is based of the [musl](https://musl.libc.org/) libc library, which is a minimal (and far from fully compatible) the GNU libc library which provides the standard C library and POSIX API most linux distros are based of. Complex software (eg, the oc library) which is built against [glibc](https://www.gnu.org/software/libc/) will not (likely) work with musl-libc, even with symlinking. See this rather excellent explanation [here](https://stackoverflow.com/questions/66963068/docker-alpine-executable-binary-not-found-even-if-in-path)


Finally, the "ENTRYPOINT" and "CMD" directives in this Dockerfile do not really matter. The script provided in the task itself is the pod's "CMD/ARGS". The aforementined directives get overriden.