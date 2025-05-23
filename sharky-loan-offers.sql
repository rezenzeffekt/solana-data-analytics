with txs as (

-- single loan offer
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[0]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where (contains (log_messages[1],'OfferLoan') or contains (log_messages[5],'OfferLoan'))
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[2] is null
and (instructions[0]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM' or instructions[2]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM')
union all
-- 2 loans offered 
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[0]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[1],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[2] is not null
and signers[3] is null
and instructions[0]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[1]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[1],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[2] is not null
and signers[3] is null
and instructions[0]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
-- 3 loans offered 
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[0]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[1],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[0]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[1]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[1],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[0]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[2]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[1],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[0]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
-- 3 loans offered (reverse ordering)
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[0]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[5],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[2]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[1]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[5],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[2]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'
union all
select tx_id, block_timestamp as datetime, signers[0] as lender, inner_instructions[2]:instructions[2]:parsed:info:destination as escrow_token
from solana.core.fact_transactions
where contains (log_messages[5],'OfferLoan')
and block_timestamp > current_date() - interval '{{hours}} hours'
and succeeded
and signers[3] is not null
and signers[4] is null
and instructions[2]:accounts[6] = 'BENrqx18n8tP2xYPBQ7vaDz88Y7wSmzB1xkr8h4XrhvM'

), 
bal as (
select account_address, min(balance) as amount
from solana.core.fact_sol_balances
where account_address in (select txs.escrow_token from txs)
group by 1
)
select amount, lender, datetime --, tx_id
from txs
join bal on bal.account_address = txs.escrow_token
order by 1 desc
;