plot4 <- function () {
        
        ## Function plots 4 panels of power time-series data over 2-day period,
        ## Feb 1, 2007 and Feb 2, 2007.
        ## First panel plots the household global minute-averaged active power 
        ## (in kilowatt, kW)
        ## Second panel plots the minute-averaged voltage (in volt).
        ## Third panels plots the energy (watt-hour of active energy) from 3
        ## submeters--Submeter_1 from the kitchen; Submeter_1 from the landry
        ## room; Submeter_3 from the electric water heater and air conditioner.
        ## Fourth panel plots the household global minute-averaged reactive 
        ## power (in kilowatt)
        
        ## Checks if the dataset has been downloaded and unzipped in the
        ## power directory within the working directory. If the dataset, does
        ## not exists, dataset is downloaded.
        
        url<- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        if (!file.exists("./power/household_power_consumption.txt")){
                message("Downloading data")
                install.packages("downloader"); library(downloader)
                download(url, destfile = './data_power.zip')
                unzip ("data_power.zip", exdir ="./power")
        }
                
        ## Loads the dataset using fread. It only reads the data starting
        ## on 1/2/2007, dd/mm/yyyy and the next 2880 rows. Because analysis is
        ## being conducted on 1/2/2007 and 2/2/2007 and data was sampled every
        ## minute, there are 1440 records per 24 hour period.

        library(data.table)
        DB <- fread("./power/household_power_consumption.txt", 
                    header=FALSE, skip="1/2/2007", nrows=2880, sep=";", 
                    na.strings="?")
        VV <- fread("./power/household_power_consumption.txt",
                    nrows=0, sep=";", na.strings="?")
        setnames(DB, colnames(DB), colnames(VV))
        
        ## Binds the date/time variable into one variable, DT.
        DB[,DT:= paste(DB$Date, DB$Time)] 
        
        
        ## Opens a file device for png and stores the plot in plot4.png
        png(file="plot4.png", width=480, height=480)
        par(mfrow=c(2,2))
        
        install.packages("lubridate"); library(lubridate)
        
        with(DB, { 
             plot(dmy_hms(DB$DT), DB$Global_active_power, type='l', 
                      xlab="", ylab="Global Active Power (kilowatts)")
             
             plot(dmy_hms(DB$DT), DB$Voltage, type='l', 
                  xlab="", ylab="Voltage")
             
             yrange <- range(DB$Sub_metering_1)
             plot(dmy_hms(DB$DT), DB$Sub_metering_1, type='l', col = "black",
                  xlab="", ylab="Energy sub metering", ylim=yrange)
             par(new=TRUE)
             plot(dmy_hms(DB$DT), DB$Sub_metering_2, type='l', col = "red",
                  xlab="", ylab="", ylim=yrange, axes=F)
             par(new=TRUE)
             plot(dmy_hms(DB$DT), DB$Sub_metering_3, type='l', col = "blue",
                  xlab="", ylab="", ylim=yrange, axes=F)             
             legend("topright", lty=1, col= c("black", "red", "blue"), 
                    legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
                    y.intersp = 1, )
             par(new=FALSE)
             
             plot(dmy_hms(DB$DT), DB$Global_reactive_power, type='l', 
                  xlab="", ylab="Global_reactive_power")
             })
        dev.off()
}
