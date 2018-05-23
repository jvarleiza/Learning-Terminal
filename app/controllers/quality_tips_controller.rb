class QualityTipsController < ApplicationController
  before_action :set_quality_tip, only: [:show, :edit, :update, :destroy]

  # GET /quality_tips
  # GET /quality_tips.json
  def index
    @quality_tips = QualityTip.where([ get_query_string({department_filter: true}) ])
    # @quality_tips = QualityTip.order('name asc').paginate(page: params[:page], per_page: 3)
  end
  
  def index_admin
    @quality_tips = QualityTip.where([ get_query_string({is_admin: true}) ])
  end

  # GET /quality_tips/1
  # GET /quality_tips/1.json
  def show
  end

  # GET /quality_tips/new
  def new
    @quality_tip = QualityTip.new
  end

  # GET /quality_tips/1/edit
  def edit
  end

  # POST /quality_tips
  # POST /quality_tips.json
  def create
    @quality_tip = QualityTip.new(quality_tip_params)

    respond_to do |format|
      if @quality_tip.save
        format.html { redirect_to @quality_tip, notice: 'Quality tip was successfully created.' }
        format.json { render :show, status: :created, location: @quality_tip }
      else
        format.html { render :new }
        format.json { render json: @quality_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quality_tips/1
  # PATCH/PUT /quality_tips/1.json
  def update
    respond_to do |format|
      if @quality_tip.update(quality_tip_params)
        format.html { redirect_to @quality_tip, notice: 'Quality tip was successfully updated.' }
        format.json { render :show, status: :ok, location: @quality_tip }
      else
        format.html { render :edit }
        format.json { render json: @quality_tip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quality_tips/1
  # DELETE /quality_tips/1.json
  def destroy
    @quality_tip.destroy
    respond_to do |format|
      format.html { redirect_to quality_tips_url, notice: 'Quality tip was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quality_tip
      @quality_tip = QualityTip.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quality_tip_params
      params.require(:quality_tip).permit(:name, :description, :locale, :departments,
                                          :countries, :building_types, :inactive)
    end
end
