--Data Brain
function c511002999.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,110000104))
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(53610653,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c511002999.descon)
	e4:SetOperation(c511002999.desop)
	c:RegisterEffect(e4)
end
function c511002999.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetPreviousEquipTarget()
	return e:GetHandler():IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_DESTROY) and ec:IsReason(REASON_EFFECT) 
		and ec:GetReasonPlayer()==1-tp and ec:GetReasonEffect() and ec:GetReasonEffect():GetCode()==EVENT_FREE_CHAIN and ec:GetReasonEffect():IsActiveType(TYPE_SPELL)
end
function c511002999.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local te=ec:GetReasonEffect()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(te:GetCategory())
	e1:SetProperty(te:GetProperty())
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c511002999.accost)
	e1:SetTarget(c511002999.actg)
	e1:SetOperation(c511002999.acop)
	if Duel.GetTurnPlayer()==tp then
		e1:SetCondition(c511002999.accon2)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetCondition(c511002999.accon1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	end
	e1:SetLabelObject(te)
	c:RegisterEffect(e1)
end
function c511002999.accon1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local con=te:GetCondition()
	return (not con or con(e,tp,eg,ep,ev,re,r,rp))
end
function c511002999.accon2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local con=te:GetCondition()
	return Duel.GetTurnCount()~=e:GetLabel() and (not con or con(e,tp,eg,ep,ev,re,r,rp))
end
function c511002999.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	local cost=te:GetCost()
	if chk==0 then return (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) end
	if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c511002999.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=e:GetLabelObject()
	local tg=te:GetTarget()
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c511002999.desop2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c511002999.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c511002999.acop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	if bit.band(te:GetHandler():GetType(),TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
		e:GetHandler():CancelToGrave(false)
	end
end
