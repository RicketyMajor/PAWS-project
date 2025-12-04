import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    try {
      const user = this.userRepo.create(createUserDto);
      await this.userRepo.save(user);

      return user;
    } catch (error) {
      console.log(error);
      this.handleErrors(error);
    }
  }

  async findOneById(id: string): Promise<User> {
    return this.userRepo.findOneBy({ id });
  }

  async findOneByEmail(email: string): Promise<User> {
    const user = await this.userRepo.findOneBy({ email });

    if (!user)
      throw new BadRequestException('Este usuario no se encuentra registrado');
    if (!user.isVerified)
      throw new UnauthorizedException('Usuario no verificado');

    return user;
  }

  async findManyByIds(userIds: string[]): Promise<User[]> {
    return this.userRepo.find({
      where: { id: In(userIds) },
    });
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    await this.userRepo.update(id, updateUserDto);
    return this.userRepo.findOneBy({ id });
  }

  async remove(id: number): Promise<string> {
    const user = await this.userRepo.delete(id);
    if (!user.affected) {
      return 'Usuario no encontrado';
    }
    return 'Usuario eliminado con exito';
  }

  async updateWithEmail(
    email: string,
    updateUserDto: UpdateUserDto,
  ): Promise<User> {
    const user = await this.userRepo.findOneBy({ email });
    const id = user.id;
    await this.userRepo.update(id, updateUserDto);
    return this.userRepo.findOneBy({ id });
  }

  async updateVerificationCode(id: string, verificationCode: number) {
    await this.userRepo.update(id, { verification_code: verificationCode });
  }

  async updateActive(id: string, isVerified: boolean) {
    await this.userRepo.update(id, { isVerified });
  }

  private handleErrors(error: any) {
    if (error.code === '23505')
      throw new BadRequestException('Usuario ya registrado');
  }
}
