import { BeforeInsert, Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity({ name: 'users' })
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('varchar')
  name: string;

  @Column({ unique: true })
  email: string;

  @Column('text', {
    select: true,
  })
  password: string;

  @Column('bool', {
    default: false,
  })
  isVerified: boolean;

  @Column('int', {
    select: false,
  })
  verification_code: number;

  @BeforeInsert()
  generateVerificationCode() {
    if (!this.verification_code) {
      this.verification_code = Math.floor(100000 + Math.random() * 900000);
    }
    return;
  }

  @BeforeInsert()
  checkFieldsBeforeInsert() {
    this.email = this.email.toLocaleLowerCase().trim();
  }
}
