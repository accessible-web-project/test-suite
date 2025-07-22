A study of Open Source Web Accessibility Testing Tools
================================

This repository contains the source code for the thesis project [Incorporating Web Accessibility into a CI/CD Pipeline: A study of Open Source Evaluation Tools](https://www.diva-portal.org/smash/record.jsf?pid=diva2%3A1887999&dswid=4635) by *Elena Moser* and *Jesper Yli-Hukka Högback*. It was further developed to extend the project for the *Assessing Evaluation Tools through Accessibility Standards in Web Development - With CI/CD Pipelines* study, which can viewed here: [Assessing Evaluation Tools through Accessibility Standards in Web Development: With CI/CD Pipelines](https://urn.kb.se/resolve?urn=urn:nbn:se:lnu:diva-140096).

**Abstract**: To help ensure that websites across the internet garner compliance for web accessibility, there are defined standards known as the Web Content Accessibility Guidelines (WCAG). Accessibility evaluation tools exist to assess websites, and raise awareness for violations or warnings that can aid in development and quality assurance. This project aids further efforts to provide explainability for WCAG 2.2 criteria, with various contexts and techniques applicable to them, by developing examples onto a website built from Moser and Högback’s study “Incorporating Web Accessibility into a CI/CD Pipeline”. Additionally, with their study of conducting assessment on tools like, Axe-core, Accessibility Checker, and HTML_CodeSniffer through a CI/CD Pipeline with the use of Github Actions, we aimed to contribute to the subject by incorporating the following tools: WebAim’s WAVE, Pa11y, and Google’s Lighthouse. For the assessment of the tools’ performance, our metrics are also adopted from their study, considering the tools ability to identify violations, based on WCAG criteria, error description, and error location. From our overall analysis of the accessibility evaluation tools, we were able to determine Pa11y as the current best performing tool out of all that were tested, as it achieved a 25% average for identifying violations on the test website. This shows that the results capable of being produced by the evaluation tools still remain quite limited. Regardless of their completeness, these results still prove to be effective considering there are violations that the tools can successfully identify with descriptive information. This provides developers better clarity for finding a solution, but there still remains a need for further development on the evaluation tools themselves.

**Table of contents**
- [Test Website](#test-website)
    - [Running the web app locally with Docker](#running-the-web-app-locally-with-docker)
- [Web Accessibility evaluation tools](#web-accessibility-evaluation-tools)
    - [Testing the tools locally with bash](#testing-the-tools-locally-with-bash)
    - [Integration of tool into CI pipeline](#integration-of-tool-into-ci-pipeline)

## Test Website

For our study, we created a test website that includes WCAG violations. The purpose was to create a controlled environment for the performance assessment of the Web Accessibility testing tools. The website was designed using HTML, CSS, JavaScript and locally hosted via the Express.js framework to facilitate URL-based testing tool requirements. Composed of five pages, three are relevant for testing, namely *Perceivable*, *Operable* and *Understandable*. Violations were deliberately included on these three pages for each implemented criterion, ranging from easily detectable, like missing alternative text on images, to those requiring additional context for identification. The website maintains a consistent structure across its pages, except for the Understandable page, which intentionally deviates to highlight the criterion of consistent navigation. This deviation involves swapping the positions of the header and footer elements. Each page follows a standardized layout: a main heading, followed by a guideline and its corresponding criterion. Typically, the criterion section includes explanatory text followed by examples displayed in two boxes: one green, indicating correct implementation, and one red, depicting incorrect approaches. Additional information, denoted by a yellow box, may accompany certain criteria, showcasing existing implementation, examples from other pages, or relevant details. The examples created are mostly derived directly from those provided by [W3C](https://www.w3.org/TR/WCAG21/). For rules lacking clear examples or any examples at all, we had to formulate our own interpretations based on the information provided by [W3C](https://www.w3.org/TR/WCAG21/).

The published website by Moser and Högback can accessed via this link: [https://idasm-unibe-ch.github.io/unibe-web-accessibility/](https://idasm-unibe-ch.github.io/unibe-web-accessibility/). Our updated version can temporarily be found here: [Evaluation Webpage for Web Accessibility Testing Tools](https://accessible-web-project.github.io/test-suite/).

For more details about the test website, please refer to the PDF copy of the thesis.

### Running the web app locally with Docker

The web application can be run locally with docker and viewed in your browser of choice at [http://localhost:1338/](http://localhost:1338/).

```
# to run server in background
docker compose up -d server

# to shut down
docker compose down
```
These commands are also available via the test.bash script (see below).

## Web Accessibility evaluation tools

In Moser and Högback's study, they examined [Deque Systems’ Axe-Core CLI](https://www.npmjs.com/package/@axe-core/cli), [Squiz Labs’ HTML_CodeSniffer](https://www.npmjs.com/package/html_codesniffer), [IBM’s Equal Access Accessibility Checker](https://www.npmjs.com/package/accessibility-checker), and [Asqatasun](https://asqatasun.org/). We added [Lighthouse](https://developer.chrome.com/docs/lighthouse/overview), [Pa11y](https://pa11y.org/), and [WAVE API](https://wave.webaim.org/api/).
For more details about the tools examined in this investigation, please refer to the PDF copy of the thesis.

### Testing the tools locally with bash

In order to test the different tools locally, we created a bash-script.

```
# to view intructions
./test.bash
```

In order to obtain the audit results for the webpages of the published test website follow the following steps:

```
# Start by running an audit for each webpage
# with the Accessibility-checker
./test.bash setup achecker
./test.bash run achecker https://idasm-unibe-ch.github.io/unibe-web-accessibility
./test.bash cleanup achecker

# with Axe 
./test.bash setup axe
./test.bash run axe https://idasm-unibe-ch.github.io/unibe-web-accessibility/
./test.bash cleanup axe

# with HTML_CodeSniffer 
./test.bash setup htmlcs
./test.bash run htmlcs https://idasm-unibe-ch.github.io/unibe-web-accessibility
./test.bash cleanup htmlcs

# with Asqatasun
asqatasun-docker/asqatasun_audit.bash setup
asqatasun-docker/asqatasun_audit.bash run
# NOTE: The results need to be downloaded separately.
# Substitute the id below with the audit id to download.
asqatasun-docker/asqatasun_audit.bash audit <id>
asqatasun-docker/asqatasun_audit.bash cleanup

# Now all results have been saved 
# and you can generate (see results/): 
# report.json
# error_overview.csv
# error_summary_overview.csv
./generate_report.bash

---------------------------------------------------------

# with Lighthouse 
./test.bash setup lighthouse
./test.bash run lighthouse https://accessible-web-project.github.io/test-suite/
./test.bash cleanup lighthouse

# with Pa11y 
./test.bash setup pa11y
./test.bash run pa11y https://accessible-web-project.github.io/test-suite/
./test.bash cleanup pa11y

# with WAVE API 
./test.bash setup wave
./test.bash run wave https://accessible-web-project.github.io/test-suite/
./test.bash cleanup wave
```

Given our project deadlines, we haven't had the chance to fully automate the process of running each tool on every web page of the test website just yet.
It is however possible to download the audit results for each tool as artifacts by going to the respective GitHub Actions workflows, i.e. [*.github/workflows/testing_tools_audits.yml*](https://github.com/robinkxl/thesis-project/actions/workflows/testing_tools_audits.yml) and for Aquatasun from [*.github/workflows/asqatasun_audits.yml*](https://github.com/idasm-unibe-ch/unibe-web-accessibility/actions/workflows/asqatasun_audits.yml).

We were not able to set up Lighthouse and Pa11y to print the results into GitHub Actions' Artifacts, so that remains a task for future work. They results for Lighthouse can be found under the "Run Lighthouse CI" step as HTML pages stored on Google Cloud Storage. Pa11y's results are printed in the workflow's logs under the "Run pa11y-ci" step.

WAVE API ended up being incompatible with our implementation of a CI pipeline since it does not assess localhost websites, so we run it on the already deployed version of the test website.

### Integration of tool into CI pipeline 

The GitHub Actions workflow *.github/workflows/example_ci.yml* was created as an [example](https://github.com/idasm-unibe-ch/unibe-web-accessibility/actions/workflows/example_ci.yml) of how to integrate the tools into a CI pipeline.
