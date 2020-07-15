class ShowsController < ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy, :show_access]
  before_action :authenticate_user!
  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
  end

  # GET /shows/new
  def new
    @show = Show.new
  end

  # GET /shows/1/edit
  def edit
  end

  # POST /shows
  # POST /shows.json
  def create
    @show = Show.new(show_params)
    @show.user = current_user
    @show.meeting_id = SecureRandom.hex(10)
    respond_to do |format|
      if @show.save
        format.html { redirect_to user_shows_path(current_user), notice: 'Show was successfully created.' }
        format.json { render :show, status: :created, location: @show }
      else
        format.html { render :new }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  def show_access
    url_base = "https://tarimavirtual3.kodim.tech/bigbluebutton/api/"
    room_id = @show.meeting_id
    full_names = "#{current_user.last_name}+#{current_user.first_name}"
    attendee_pw = 'ap'
    moderator_pw = 'mp'

    string_to_checksum = "getMeetingInfo?meetingID=#{room_id}n2xZ9tJAi870q7ns9xtPuogGkyAALpJ0HGBhGXbzhPM"
    get_checksum = Digest::SHA1.hexdigest string_to_checksum
    response_url = HTTParty.get("#{url_base}getMeetingInfo?meetingID=#{room_id}&checksum=#{get_checksum}")

    data_response = response_url.parsed_response.to_json
    json = JSON.parse(data_response)

    if json['response']['returncode'] == 'FAILED'
      
      create_meeting(url_base, room_id, moderator_pw, attendee_pw)
      
      string_to_join = "joinfullName=#{full_names}&password=#{moderator_pw}&meetingID=#{room_id}&redirect=truen2xZ9tJAi870q7ns9xtPuogGkyAALpJ0HGBhGXbzhPM"
      join_checksum = Digest::SHA1.hexdigest string_to_join
      redirect_to "#{url_base}join?fullName=#{full_names}&password=#{moderator_pw}&meetingID=#{room_id}&redirect=true&checksum=#{join_checksum}"
    elsif json['response']['returncode'] == 'SUCCESS'
      string_to_join = "joinfullName=#{full_names}&password=#{moderator_pw}&meetingID=#{room_id}&redirect=truen2xZ9tJAi870q7ns9xtPuogGkyAALpJ0HGBhGXbzhPM"
      join_checksum = Digest::SHA1.hexdigest string_to_join
      redirect_to "#{url_base}join?fullName=#{full_names}&password=#{moderator_pw}&meetingID=#{room_id}&redirect=true&checksum=#{join_checksum}"
    end
  end

  def create_meeting(url_base, room_id, moderator_pw, attendee_pw)
    string_to_create = "createmeetingID=#{room_id}&moderatorPW=#{moderator_pw}&attendeePW=#{attendee_pw}n2xZ9tJAi870q7ns9xtPuogGkyAALpJ0HGBhGXbzhPM"
    create_checksum = Digest::SHA1.hexdigest string_to_create
    create_response = HTTParty.post("#{url_base}create?meetingID=#{room_id}&moderatorPW=#{moderator_pw}&attendeePW=#{attendee_pw}&checksum=#{create_checksum}")
  end

  # PATCH/PUT /shows/1
  # PATCH/PUT /shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to @show, notice: 'Show was successfully updated.' }
        format.json { render :show, status: :ok, location: @show }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shows/1
  # DELETE /shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to shows_url, notice: 'Show was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def show_params
      params.require(:show).permit(:image, :title, :content, :date, :duration, :user_id)
    end
end
