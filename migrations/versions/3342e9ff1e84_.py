"""empty message

Revision ID: 3342e9ff1e84
Revises: 0d20ee4105a4
Create Date: 2022-07-16 03:07:31.973855

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '3342e9ff1e84'
down_revision = '0d20ee4105a4'
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('persons')
    op.drop_table('questions')
    op.drop_table('tests')
    op.drop_table('test_question')
    op.drop_table('psychiatrists')
    op.drop_table('patients')
    op.drop_table('options')
    op.drop_table('counselling_suggestion')
    op.drop_table('roles')
    op.drop_table('answer')
    op.drop_table('test_results')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('test_results',
    sa.Column('test_result_id', sa.INTEGER(), server_default=sa.text("nextval('test_results_test_result_id_seq'::regclass)"), autoincrement=True, nullable=False),
    sa.Column('test_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('patient_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('submitted_at', postgresql.TIMESTAMP(), server_default=sa.text('CURRENT_TIMESTAMP'), autoincrement=False, nullable=False),
    sa.Column('verifier_id', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('verified_at', postgresql.TIMESTAMP(), autoincrement=False, nullable=True),
    sa.Column('machine_report', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('manual_report', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['patient_id'], ['patients.patient_id'], name='test_results_patient_id_fkey'),
    sa.ForeignKeyConstraint(['test_id'], ['tests.test_id'], name='test_results_test_id_fkey'),
    sa.ForeignKeyConstraint(['verifier_id'], ['psychiatrists.psychiatrist_id'], name='test_results_verifier_id_fkey'),
    sa.PrimaryKeyConstraint('test_result_id', name='test_results_pkey'),
    postgresql_ignore_search_path=False
    )
    op.create_table('answer',
    sa.Column('test_result_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('option_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['option_id'], ['options.option_id'], name='answer_option_id_fkey'),
    sa.ForeignKeyConstraint(['test_result_id'], ['test_results.test_result_id'], name='answer_test_result_id_fkey'),
    sa.PrimaryKeyConstraint('test_result_id', 'option_id', name='answer_pkey')
    )
    op.create_table('roles',
    sa.Column('id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('name', sa.VARCHAR(length=64), autoincrement=False, nullable=True),
    sa.PrimaryKeyConstraint('id', name='roles_pkey'),
    sa.UniqueConstraint('name', name='roles_name_key')
    )
    op.create_table('counselling_suggestion',
    sa.Column('test_result_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('psychiatrist_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['psychiatrist_id'], ['psychiatrists.psychiatrist_id'], name='counselling_suggestion_psychiatrist_id_fkey'),
    sa.ForeignKeyConstraint(['test_result_id'], ['test_results.test_result_id'], name='counselling_suggestion_test_result_id_fkey'),
    sa.PrimaryKeyConstraint('test_result_id', 'psychiatrist_id', name='counselling_suggestion_pkey')
    )
    op.create_table('options',
    sa.Column('option_id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('option_text', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('score', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('question_id', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['question_id'], ['questions.question_id'], name='options_question_id_fkey'),
    sa.PrimaryKeyConstraint('option_id', name='options_pkey')
    )
    op.create_table('patients',
    sa.Column('height_inches', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('weight_kgs', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.Column('location', sa.VARCHAR(), autoincrement=False, nullable=True),
    sa.Column('patient_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['patient_id'], ['persons.person_id'], name='patients_patient_id_fkey'),
    sa.PrimaryKeyConstraint('patient_id', name='patients_pkey')
    )
    op.create_table('psychiatrists',
    sa.Column('psychiatrist_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('is_verified', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.Column('available_times', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['psychiatrist_id'], ['persons.person_id'], name='psychiatrists_psychiatrist_id_fkey'),
    sa.PrimaryKeyConstraint('psychiatrist_id', name='psychiatrists_pkey'),
    postgresql_ignore_search_path=False
    )
    op.create_table('test_question',
    sa.Column('test_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('question_id', sa.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('is_approved', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['question_id'], ['questions.question_id'], name='test_question_question_id_fkey'),
    sa.ForeignKeyConstraint(['test_id'], ['tests.test_id'], name='test_question_test_id_fkey'),
    sa.PrimaryKeyConstraint('test_id', 'question_id', name='test_question_pkey')
    )
    op.create_table('tests',
    sa.Column('test_id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('name', sa.VARCHAR(length=64), autoincrement=False, nullable=False),
    sa.Column('description', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('created_at', postgresql.TIMESTAMP(), autoincrement=False, nullable=False),
    sa.Column('is_approved', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.Column('psychiatrist_id_of_added_by', sa.INTEGER(), autoincrement=False, nullable=True),
    sa.ForeignKeyConstraint(['psychiatrist_id_of_added_by'], ['psychiatrists.psychiatrist_id'], name='tests_psychiatrist_id_of_added_by_fkey'),
    sa.PrimaryKeyConstraint('test_id', name='tests_pkey')
    )
    op.create_table('questions',
    sa.Column('question_id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('question_text', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('created_at', postgresql.TIMESTAMP(), autoincrement=False, nullable=True),
    sa.Column('is_approved', sa.BOOLEAN(), autoincrement=False, nullable=True),
    sa.PrimaryKeyConstraint('question_id', name='questions_pkey')
    )
    op.create_table('persons',
    sa.Column('person_id', sa.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('name', sa.VARCHAR(length=64), autoincrement=False, nullable=True),
    sa.Column('email', sa.VARCHAR(length=64), autoincrement=False, nullable=True),
    sa.Column('password_hash', sa.VARCHAR(length=256), autoincrement=False, nullable=True),
    sa.Column('date_of_birth', postgresql.TIMESTAMP(), autoincrement=False, nullable=True),
    sa.Column('gender', sa.VARCHAR(length=1), autoincrement=False, nullable=True),
    sa.Column('photo_path', sa.VARCHAR(length=128), autoincrement=False, nullable=True),
    sa.Column('cellphone', sa.VARCHAR(length=12), autoincrement=False, nullable=True),
    sa.PrimaryKeyConstraint('person_id', name='persons_pkey')
    )
    # ### end Alembic commands ###