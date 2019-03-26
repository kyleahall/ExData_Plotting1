## Since this is a very large file, and I'm reading it all into memory, this function is full of conditions
## to avoid duplicating bandwidth or memory intensive actions.

# Avoid downloading the file if it already exists in the WD, otherwise download
if(!file.exists("Power Consumption.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                "./Power Consumption.zip", method = "curl")
}
# Avoid extracting the file if it already exists in the WD, otherwise unzip to Power Consumption
if(!file.exists("./Power Consumption")) {
  unzip("Power Consumption.zip", exdir = "./Power Consumption")
}

# Avoid reading the table into memory if filtered rows already exist, otherwise read and filter
if(!exists("epcdata")) {
  epcdata <- read.table("./Power Consumption/household_power_consumption.txt", 
                        na.strings = "?", sep = ";", header = TRUE)
  epcdata <- epcdata[epcdata$Date == "1/2/2007" | epcdata$Date == "2/2/2007", ]
}

# Save current graphical parameters to reset after creating PNG
prevpars <- par()

# Open a PNG device named plot1.png
png('plot1.png', bg = 'transparent')

# Add a red histogram of global active power with appropriate labels to plot1.png
hist(epcdata$Global_active_power, col = 'red', main = 'Global Active Power', 
     xlab = 'Global Active Power (killowatts)')

# Close the connection to the device & reset pars
dev.off()
par(prevpars)