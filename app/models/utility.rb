class Utility < ApplicationRecord
    # https://stackoverflow.com/questions/4410794/ruby-on-rails-import-data-from-a-csv-file
    # https://stackoverflow.com/questions/41314784/getting-unknownattributeerror-in-rake-using-csv-attribute-exists-in-rails-app
    # Use Number to export to CSV

    def self.readAbaCSV
        filename = File.join(Rails.root, 'app', 'csv', 'ABA_Checklist-8.0.6a.csv')
        CSV.foreach(filename, headers: true) do |row|
            if (row["common_name"])
                Bird.create(row.to_hash)
            end
        end
    end

    def self.readEbirdCSV
        filename = File.join(Rails.root, 'app', 'csv', 'eBird_Taxonomy_v2019.csv')
        CSV.foreach(filename, headers: true) do |row|
            if found_bird = Bird.all.find_by(sci_name: row["sci_name"]) || Bird.all.find_by(common_name: row["primary_com_name"]) 
                found_bird.taxon_order = row["taxon_order"]
                found_bird.ebird_species_code = row["species_code"]
                found_bird.save

            end
        end
    end

    def self.addAppledoreFlag
        appledore_birds = ["ACFL", "ALFL", "AMGO", "AMRE", "AMRO", "BAOR", "BARS", "BAWW", "BBCU", "BBWA", "BCCH", "BEKI", "BGGN", "BHCO", "BHVI", "BITH", "BLBW", "BLGR", "BLJA", "BLPW", "BOBO", "BRCR", "BRTH", "BRWA", "BTBW", "BTNW", "BWHA", "BWWA", "CARW", "CAWA", "CCSP", "CEDW", "CERW", "CHSP", "CMWA", "COGR", "CONW", "COYE", "CSWA", "CWWI", "DICK", "DOWO", "EAKI", "EAPH", "EATO", "EAWP", "EUST", "EVGR", "FISP", "FOSP", "GCBT", "GCFL", "GCKI", "GCTH", "GRCA", "GRSP", "GWWA", "HAWO", "HERG", "HETH", "HOFI", "HOWA", "HOWR", "INBU", "KEWA", "LASP", "LAWA", "LEBI", "LEFL", "LESA", "LISP", "LOWA", "MALL", "MAWA", "MAWR", "MERL", "MODO", "MOWA", "MYWA", "NAWA", "NESP", "NOCA", "NOHA", "NOMO", "NOPA", "NOWA", "NSWO", "OCWA", "OROR", "OSFL", "OVEN", "PABU", "PHVI", "PISI", "PIWA", "PRAW", "PROW", "PUFI", "RBGR", "RBNU", "RBWO", "RCKI", "REVI", "RTHU", "RUBL", "RWBL", "SAVS", "SCJU", "SCTA", "SEPL", "SESP", "SORA", "SOSA", "SOSP", "SPSA", "SSHA", "SUTA", "SWSP", "SWTH", "TEWA", "TRES", "TRFL", "VEER", "WAVI", "WBNU", "WCSP", "WEKI", "WEVI", "WEWA", "WIWA", "WIWR", "WOTH", "WPWA", "WPWI", "WTSP", "YBCH", "YBCU", "YBFL", "YBSA", "YEWA", "YPWA", "YSFL", "YTVI", "YTWA"]
        appledore_birds.each do |bird_code|
            if found_bird = Bird.all.find_by(four_letter_code: bird_code)
                found_bird.appledore = true
                found_bird.save
            end
        end
    end

    def self.checkForMissingBirds
        lost_codes = []
        appledore_birds = ["ACFL", "ALFL", "AMGO", "AMRE", "AMRO", "BAOR", "BARS", "BAWW", "BBCU", "BBWA", "BCCH", "BEKI", "BGGN", "BHCO", "BHVI", "BITH", "BLBW", "BLGR", "BLJA", "BLPW", "BOBO", "BRCR", "BRTH", "BRWA", "BTBW", "BTNW", "BWHA", "BWWA", "CARW", "CAWA", "CCSP", "CEDW", "CERW", "CHSP", "CMWA", "COGR", "CONW", "COYE", "CSWA", "CWWI", "DICK", "DOWO", "EAKI", "EAPH", "EATO", "EAWP", "EUST", "EVGR", "FISP", "FOSP", "GCBT", "GCFL", "GCKI", "GCTH", "GRCA", "GRSP", "GWWA", "HAWO", "HERG", "HETH", "HOFI", "HOWA", "HOWR", "INBU", "KEWA", "LASP", "LAWA", "LEBI", "LEFL", "LESA", "LISP", "LOWA", "MALL", "MAWA", "MAWR", "MERL", "MODO", "MOWA", "MYWA", "NAWA", "NESP", "NOCA", "NOHA", "NOMO", "NOPA", "NOWA", "NSWO", "OCWA", "OROR", "OSFL", "OVEN", "PABU", "PHVI", "PISI", "PIWA", "PRAW", "PROW", "PUFI", "RBGR", "RBNU", "RBWO", "RCKI", "REVI", "RTHU", "RUBL", "RWBL", "SAVS", "SCJU", "SCTA", "SEPL", "SESP", "SORA", "SOSA", "SOSP", "SPSA", "SSHA", "SUTA", "SWSP", "SWTH", "TEWA", "TRES", "TRFL", "VEER", "WAVI", "WBNU", "WCSP", "WEKI", "WEVI", "WEWA", "WIWA", "WIWR", "WOTH", "WPWA", "WPWI", "WTSP", "YBCH", "YBCU", "YBFL", "YBSA", "YEWA", "YPWA", "YSFL", "YTVI", "YTWA"]
        appledore_birds.each do |bird_code|
            if !found_bird = Bird.all.find_by(four_letter_code: bird_code)
                lost_codes << bird_code
            end
        end
        lost_codes
    end
end