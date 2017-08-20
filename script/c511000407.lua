--呪い移し
function c511000407.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511000407.condition)
	e1:SetTarget(c511000407.target)
	e1:SetOperation(c511000407.activate)
	c:RegisterEffect(e1)
end
function c511000407.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp and Duel.IsChainDisablable(ev)
end
function c511000407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c511000407.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		local c=e:GetHandler()
		if not re or not c511001939.cfilter(tc,e,tp,eg,ep,ev,re,r,rp,chain) then return end
		local tpe=tc:GetType()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
				if fc then Duel.Destroy(fc,REASON_RULE) end
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			else
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
		end	
		Duel.ClearTargetCard()
		local tg=re:GetTarget()
		e:SetCategory(re:GetCategory())
		e:SetProperty(re:GetProperty())
		if re:GetCode()==EVENT_CHAINING then
			local chain=Duel.GetCurrentChain()-1
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			if tg then tg(e,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
		elseif re:GetCode()==EVENT_FREE_CHAIN then
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
			if tg then tg(e,tp,teg,tep,tev,tre,tr,trp,1) end
		end
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			c:CancelToGrave(false)
		else
			c:CancelToGrave(true)
			local code=re:GetHandler():GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x1fc0000,1)
		end
		local op=re:GetOperation()
		if re:GetCode()==EVENT_CHAINING then
			local chain=Duel.GetCurrentChain()-1
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			if op then op(e,tp,g,p,chain,te2,REASON_EFFECT,p) end
		elseif re:GetCode()==EVENT_FREE_CHAIN then
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
			if op then op(e,tp,teg,tep,tev,tre,tr,trp) end
		end
	end
end
