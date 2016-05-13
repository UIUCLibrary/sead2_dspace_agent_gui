class DepositsController < ApplicationController
  before_action :set_deposit, only: [:show, :edit, :update, :destroy]

  # GET /deposits
  # GET /deposits.json
  def index
    @deposits = Deposit.all
  end

  # GET /deposits/1
  # GET /deposits/1.json
  def show
    @deposit = Deposit.find( params[:id] )
    t = true
  end

  # GET /deposits/new
  def new
    @deposit = Deposit.new
  end

  # GET /deposits/1/edit
  def edit
  end

  # POST /deposits
  # POST /deposits.json
  def create
    @deposit = Deposit.new(deposit_params)

    respond_to do |format|
      if @deposit.save
        format.html { redirect_to @deposit, notice: 'Deposit was successfully created.' }
        format.json { render :show, status: :created, location: @deposit }
      else
        format.html { render :new }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
    # runner = Sead2DspaceAgent::Runner.new
    # deposit = Deposit.find_by(params[:id])
    #
    # # if deposit
    # runner.run
    # # end
    # params[:deposit_ids]
    # redirect_to root_url
  end

  # def complete
  #   Deposit.update_all(["completed_at = ?", Time.now], @deposit.status = "Success", :id => params[:deposit_ids])
  # end

  # PATCH/PUT /deposits/1
  # PATCH/PUT /deposits/1.json
  def update
    respond_to do |format|
      if @deposit.update(deposit_params)
        format.html { redirect_to @deposit, notice: 'Deposit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deposit }
      else
        format.html { render :edit }
        format.json { render json: @deposit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deposits/1
  # DELETE /deposits/1.json
  def destroy
    @deposit.destroy
    respond_to do |format|
      format.html { redirect_to deposits_url, notice: 'Deposit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /deposits/1/accept
  def accept
    @deposit = Deposit.find(params[:id])
    # if accept = true then run code to process the ro
    # else run code to reject it
    if :accept == true
      sead_api = SeadApi.new
      dspace_connection = DspaceConnection.new
      ro = sead_api.get_ro


    end

    redirect_to deposits_url, notice: "Deposit #{@deposit.id} accepted!"
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_deposit
    @deposit = Deposit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def deposit_params
    params.require(:deposit).permit(:email, :title, :creator, :creation_date, :abstract, :project_url, :status)
  end
end