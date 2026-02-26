class StoresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_store, only: [:show, :edit, :update, :dashboard]

  def index
    @stores = current_user.stores
  end

  def show
    authorize_store!
  end

  def new
    @store = current_user.stores.build
  end

  def create
    @store = current_user.stores.build(store_params)

    if @store.save
      redirect_to @store, notice: "Loja criada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize_store!
  end

  def update
    authorize_store!

    if @store.update(store_params)
      redirect_to @store, notice: "Loja atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def dashboard
    authorize_store!

    @conversion_rate = Attendance.conversion_rate(@store)
    @total_attendances = @store.attendances.today(@store).count
    @sales = @store.attendances.today(@store).sales.count

    durations = @store.attendances.today(@store).map(&:duration_minutes).compact
    @average_attendance_time = durations.any? ? (durations.sum.to_f / durations.length).round(1) : 0
  end

  private

  def set_store
    @store = Store.find(params[:id])
  end

  def authorize_store!
    redirect_to stores_path, alert: "Acesso negado" unless @store.user == current_user
  end

  def store_params
    params.require(:store).permit(:name, :cnpj, :phone, :timezone)
  end
end
