class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_store, only: [:create]
  before_action :set_attendance, only: [:finish]

  # POST /stores/:store_id/attendances
  # Start a new attendance for the current user
  def create
    @attendance = @store.attendances.build(seller: current_user, started_at: Time.current)

    if @attendance.save
      # Update seller queue status to "attending"
      queue_status = SellerQueueStatus.find_or_create_by(store: @store, seller: current_user)
      queue_status.update(status: "attending")

      redirect_to @store, notice: "Atendimento iniciado. Clique em 'Finalizar' quando terminar."
    else
      redirect_to @store, alert: "Erro ao iniciar atendimento: #{@attendance.errors.full_messages.join(', ')}"
    end
  end

  # PATCH /attendances/:id/finish
  # Finish an attendance and record the result
  def finish
    if params[:result].blank?
      return redirect_to store_path(@attendance.store), alert: "Informe o resultado do atendimento"
    end

    @attendance.update(ended_at: Time.current, result: params[:result])

    # Move seller back to idle
    queue_status = SellerQueueStatus.find_by(store: @attendance.store, seller: @attendance.seller)
    if queue_status
      queue_status.update(status: "idle")
      # Update position to end of queue (or let queue service handle this)
      next_position = SellerQueueStatus.where(store: @attendance.store, status: "idle").maximum(:position) || 0
      queue_status.update(position: next_position + 1)
    end

    redirect_to store_path(@attendance.store), notice: "Atendimento finalizado."
  end

  private

  def set_store
    @store = Store.find(params[:store_id])
    authorize_store!
  end

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def authorize_store!
    redirect_to root_path, alert: "Acesso negado" unless @store.user == current_user || current_user.manager? || current_user.seller?
  end
end
