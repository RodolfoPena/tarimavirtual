class PagesController < ApplicationController
    def home
        @shows = Show.all
        @today_shows = Show.where("DATE(date)=?", Date.today)
    end
end