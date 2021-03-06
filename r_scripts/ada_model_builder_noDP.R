#!/usr/bin/env R

require("ada")

args <- commandArgs(TRUE)

train_filename = args[1]

##### Main (entry point)
train_data = read.table(train_filename, header=TRUE)

if ( !(1 %in% train_data$TrueVariant_or_False && 0 %in% train_data$TrueVariant_or_False) ) {
    stop("In training mode, there must be both true positives and false positives in the call set.")
}

train_data <- train_data[,-c(1, 2, 3, 4, 5)]

train_data[,'REF'] <- NULL
train_data[,'ALT'] <- NULL
train_data[,'if_COSMIC'] <- NULL
train_data[,'COSMIC_CNT'] <- NULL

train_data$SOR <- as.numeric(train_data$SOR)

model_formula <- as.formula(TrueVariant_or_False ~ .)

print("Fitting model...")
ada.model <- ada(model_formula, data = train_data, iter = 500)

save(ada.model, file = paste(train_filename, ".noDP.Classifier.RData", sep="") )

print(ada.model)
