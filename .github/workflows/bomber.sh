name: "Bomber Scan SBOM"

on:
  push:
    branches:
    - master

jobs:
  Pipeline-Job:
    # Configure Environment
    name: 'Bomber Scan SBOM'
    runs-on: ubuntu-latest
    env: 
      SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
       
    steps:
    # Checkout Code
    - name: Checkout Code
      uses: actions/checkout@v1

    # Install Bomber
    - name: Install Bomber
      run: |
         wget --progress=bar:force:noscroll "https://github.com/devops-kung-fu/bomber/releases/download/v${VERSION}/bomber_${VERSION}_linux_amd64.deb" && sudo dpkg --install "bomber_${VERSION}_linux_amd64.deb"
    - name: Archive Scan Results
      uses: actions/upload-artifact@v2
      with:
          name: Archive Scan Results
          path: |
            nodejs-goof_cyclonedx.json
