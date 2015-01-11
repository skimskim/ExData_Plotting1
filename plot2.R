plot2 <- function () {
        
        ## Function plots the time series data of household global 
        ## minute-averaged active power (in kilowatt, kW) over two-day period,
        ## Feb 1, 2007 and Feb 2, 2007.
        
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
        
        
        ## Opens a file device for png and stores the plot in plot2.png
        png(file="plot2.png", width=480, height=480)
        install.packages("lubridate"); library(lubridate)
        with(DB, plot(dmy_hms(DB$DT), DB$Global_active_power, type='l', 
                      xlab="", ylab="Global Active Power (kilowatts)"))
        dev.off()
        
}
