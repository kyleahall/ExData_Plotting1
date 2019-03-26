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

# Create a datetime column by combining date and time for plotting
epcdata$dtime <- strptime(paste0(epcdata$Date, " ", epcdata$Time), "%d/%m/%Y %H:%M:%S")

# Save current graphical parameters to reset after creating PNG
prevpars <- par()

# Open a PNG device named plot3.png
png('plot3.png', bg = 'transparent')

# Add a line chart of Global Active Power over time
plot(epcdata$dtime, epcdata$Sub_metering_1, ylab = 'Energy sub metering', 
     xlab = "", type = "n")

lines(epcdata$dtime, epcdata$Sub_metering_1, col="black", type = "l")
lines(epcdata$dtime, epcdata$Sub_metering_2, col="red")
lines(epcdata$dtime, epcdata$Sub_metering_3, col="blue")

legend("topright", names(epcdata)[7:9], col=c("black", "red", "blue"), lty = 1)

# Close the connection to the device & reset pars
dev.off()
par(prevpars)