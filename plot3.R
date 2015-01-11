plot3 <- function () {
        
        ## Function plots the time series data of 3 sub-meters over two-day
        ## period, Feb 1, 2007 and Feb 2, 2007.
        ## Sub_meter_1 is the measurement of energy from sub-meter No. 1 
        ## (in watt-hour of active energy). It corresponds to the kitchen, 
        ## containing mainly a dishwasher, an oven and a microwave (hot plates 
        ## are not electric but gas powered).
        ## Sub_meter_2 is the measureent of energy from sub_meter No. 2
        ## (in watt-hour of actve energy). It corresponds to the laundry room, 
        ## containing a washing-machine, a tumble-drier, a refrigerator and a 
        ## light.
        ## Sub_meter_3 is the measuerment of energy from sub_meter NO. 3.
        ## (in watt-hour of active energy). It corresponds to the an electric 
        ## water-heater and an air-conditioner.
        
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
        
        yrange <- range(DB$Sub_metering_1)
        
        ## Opens a file device for png and stores the plot in plot3.png
        png(file="plot3.png", width=480, height=480)
        install.packages("lubridate"); library(lubridate)
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
        
        dev.off()
}
