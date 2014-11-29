
local({
    r = getOption("repos")
    r["CRAN"] = "http://cran.r-project.org/"
    options(repos = r)
})
options(browserNLdisabled = TRUE)
options("digits.secs"=3)
options(prompt="ℝ> ")
options(stringsAsFactors=TRUE)
options(showWarnCalls=TRUE)
options(showErrorCalls=TRUE)
options(error=NULL)
options(warn=0)
options(max.print=500)
options(warnPartialMatchDollar = TRUE)
Sys.setenv(LANG = "en_US.UTF-8")
Sys.setlocale("LC_COLLATE", "en_US.UTF-8")
Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")
if(! require(assertthat)){
    install.packages("assertthat")
}
library(assertthat)
if(! require(testthat)) {
    install.packages("testthat")
}
library(testthat)
if(! require(stringr)) {
    install.packages("stringr")
}
library(stringr)
if(! require(sqldf)) {
    install.packages("sqldf")
}
library(sqldf)
if(! require(MASS)) {
    install.packages("MASS")
}
library(MASS)
if(! require(jsonlite)) {
    install.packages("jsonlite")
}
library(jsonlite)
if(! require(data)) {
    install.packages("data")
}
library(data.table)
if(! require(xlsx)) {
    install.packages("xlsx")
}
library(xlsx)
if(! require(XML)) {
    install.packages("XML")
}
library(XML)
library(magrittr)
library(devtools)
if(! require(reshape2)) {
    install.packages("reshape2")
}
library(reshape2)
library(tidyr)
if(! require(lubridate)) {
    install.packages("lubridate")
}
library(lubridate)
if(! require(plyr)) {
    install.packages("plyr")
}
library(plyr)
if(! require(dplyr)) {
    install.packages("dplyr")
}
library(dplyr)
if(! require(testit)) {
    install.packages("testit")
}
library(testit)
if(! require(markdown)) {
    install.packages("markdown")
}
library(markdown)
if(! require(knitr)) {
    install.packages("knitr")
}
library(knitr)
install_github("ramnathv/slidify")
install_github("ramnathv/slidifyLibraries")
library(slidify)
if(! require(fortunes)) {
    install.packages("fortunes")
}
library(fortunes)
if(! require(ggplot2)) {
    install.packages("ggplot2")
}
library(ggplot2)
if(! require(tikzDevice)) {
    install.packages("tikzDevice")
}
library(tikzDevice)
if(! require(ascii)) {
    install.packages("ascii")
}
library(ascii)
options(asciiType="org")
if(! require(xtable)) {
    install.packages("xtable")
}
library(xtable)
if(! require(Hmisc)) {
    install.packages("Hmisc")
}
library(Hmisc)
if(! require(log4r)) {
    install.packages("log4r")
}
library(log4r)
if(! require(boot)) {
    install.packages("boot")
}
library(boot)
if(! require(kernlab)) {
    install.packages("kernlab")
}
library(kernlab)
.First <- function() {
    gcr <- new.env()
    gcr$attach.unsafe <- attach
    gcr$attach <- function(...) {
        warning("NEVER USE ATTACH! Use `unsafe.attach` if you must.")
        attach.unsafe(...)
    }
    gcr$require <- function(...) {
        warning("Are you sure you wanted `require` instead of `library`?")
        base::require(...)
    }
    gcr$lsnofun <- function(name = parent.frame()) {
        obj <- ls(name = name)
        obj[!sapply(obj, function(x) is.function(get(x)))]
    }
    gcr$recoveronerror <- function() {
        options(error=recover)
    }
    
    gcr$recoveronerroroff <- function() {
        options(error=NULL)
    }
    gcr$erroronwarn <- function() {
        options(warn=2)
    }
    
    gcr$erroronwarnoff <- function() {
        options(warn=0)
    }
    options(sqldf.driver = "SQLite")
    gcr$printdf <- function(df) {
        if (nrow(df) > 10) {
            print(head(df, 5))
            cat("---\n")
            print(tail(df, 5))
        } else {
            print(df)
        }
    }
    gcr$printlen <- function(len=500) {
        options("max.print" = len)
    }
    gcr$hundred <- function(df, idx=0) {
        df[idx:(idx+100),]
    }
    base::attach(gcr, name="gcr", warn.conflicts=FALSE)
}
fortune()
