npx elm-land build
cp -r dist v2
scp -r dist gcp:~/
rm -r v2
ssh gcp "sudo systemctl restart nginx"
