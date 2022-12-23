GOOS=linux /bin/go build -o ~/builds/overpassLinux ~/src/overpass.go
## GOOS=windows /bin/go build -o ~/builds/overpassWindows.exe ~/src/overpass.go
## GOOS=darwin /bin/go build -o ~/builds/overpassMacOS ~/src/overpass.go
## GOOS=freebsd /bin/go build -o ~/builds/overpassFreeBSD ~/src/overpass.go
## GOOS=openbsd /bin/go build -o ~/builds/overpassOpenBSD ~/src/overpass.go
echo "$(date -R) Builds completed" >> /root/buildStatus
