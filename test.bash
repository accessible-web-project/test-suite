#!/usr/bin/env bash

# Public url of test web app
WEBPAGES=("" "perceivable" "operable" "understandable")

__usage="
Usage: $(basename $0) [OPTIONS]

Tools: axe, achecker, htmlcs

Options:
  start                        Starts container for the webapp 
  setup <tool>                 Installs the dependencies for the tool
  test <tool> <url>            Audits a web page with a specific tool
  run <tool> <host>            Audits all web pages from test website with a specific tool
  cleanup <tool>               Uninstalls the dependencies to run the tool
  end                          Closes all running docker containers

Note that Asqatasun is not included here, since it works differently fromthe other tools.
To learn more and/or test Asqatasun run the following command in the terminal:
./asqatasun-docker/asqatasun_audit.bash
"
function set-up-lighthouse {
    npm install -g @lhci/cli@0.14.x
}

function run-lighthouse {
    mkdir -p results/lighthouse
    lighthouse "http://localhost:1338$1" --output html --output-path ./results/lighthouse$1-report.html
}

function clean-up-lighthouse {
    npm uninstall -g @lhci/cli
}

function set-up-pa11y {
    npm install -g pa11y-ci
    #npm install pa11y-ci-reporter-html --save
}

function run-pa11y {
    pa11y-ci $@
    echo "pa11y generated with reports"
}

function clean-up-pa11y {
    npm uninstall -g pa11y-ci
    #npm uninstall pa11y-ci-reporter-html
}

function set-up-axe {
    # axe core
    npm i @axe-core/cli
    npm install chromedriver
}

function clean-up-axe {
    # axe core
    npm uninstall @axe-core/cli
    npm uninstall chromedriver
}

function run-axe {
    mkdir -p "results/axe"
    npx axe "$1" --dir ./results/axe/
    echo "Axe-core audit generated and saved at results/axe."
}

function set-up-achecker {
    # achecker
    npm install -g accessibility-checker
}

function clean-up-achecker {
    # achecker
    npm uninstall accessibility-checker
}

function run-achecker {
    # see configuration in aceconfig.js
    npx achecker "$1"
    echo "Achecker audit generated and saved at results/achecker."
}

function set-up-htmlcs {
    # HTML_CodeSniffer
    # npm i -g grunt-cli
    npm i grunt-cli
    npm i --save html_codesniffer
    cd node_modules/html_codesniffer
    npm install
    # grunt build
    cd ../..
    npm i puppeteer
}

function clean-up-htmlcs {
    npm uninstall grunt-cli
    npm uninstall --save html_codesniffer
    npm uninstall puppeteer
}

function run-htmlcs {
    # see configuration in html_cs.js
    timestamp=$(date +%F_%H-%M-%S)
    results=$(node html_cs.js "$@" | sed 's/;/,/g')
    mkdir -p results/HTML_CodeSniffer
    echo "$@" > "results/HTML_CodeSniffer/htmlcs-results-$timestamp.txt"
    echo "$results" >> "results/HTML_CodeSniffer/htmlcs-results-$timestamp.txt"
    echo "HTML_CodeSniffer audit generated and saved at results/HTML_CodeSniffer."
}

function run-wave {
    mkdir -p results/wave
    API_KEY="$WAVE_API_KEY"
    REPORT_TYPE=3  # Get detailed JSON
    curl -s "https://wave.webaim.org/api/request?key=$API_KEY&reporttype=$REPORT_TYPE&url=$1" \
        -o "results/wave/wave-$(basename $1).json"
    echo "WAVE audit for $1 saved in results/wave."
}

function main {
    case "$1" in
        start)
            echo "Starting server..."
            docker-compose up -d server
            echo "View web app at http://localhost:1338/"
        ;;
        setup)
            set-up-$2
            echo "Ready to use $2"
        ;;
        test)
            echo "Evaluating webpage: $3"
            run-$2 "$3"
        ;;
        run)
            for page in "${WEBPAGES[@]}"
            do
                echo "Audit for webpage: $3/$page"
                run-$2 "$3/$page"
            done
        ;;
        cleanup)
            clean-up-$2
            echo "Clean up is done."
        ;;
        end)
            docker-compose down
            echo "All containers for the server are down now."
        ;;
        *)
            echo "$__usage"
    esac
   
}

# ./test.bash run axe http://localhost:1338/
# ./test.bash run axe https://idasm-unibe-ch.github.io/unibe-web-accessibility/
main "$@"