class PagesController < ApplicationController
    def home
        @shows = Show.all
    end
end