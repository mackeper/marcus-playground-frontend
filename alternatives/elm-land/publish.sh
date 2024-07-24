npm run build
cp -r dist v2
scp -r v2 gcp:~/
rm -r v2
ssh gcp "sudo systemctl restart nginx"
